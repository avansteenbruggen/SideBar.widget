options =
  city          : "weert"        # default city in case location detection fails
  region        : "LM,Netherlands"              # default region in case location detection fails
  
  units         : 'c'               # c for celcius. f for Fahrenheit
  staticLocation: false             # set to true to disable autmatic location lookup

appearance =
  iconSet       : 'yahoo'        # "original" for the original icons, or "yahoo" for yahoo icons
  color         : '#fff'            # configure your colors here
  darkerColor   : 'rgba(#fff, 0.5)'
  nightColor    : 'rgba(#008DCE, 0.8)'
  accentColor   : 'rgba(#F86A24, 1.0)'
  dayColor      : 'rgba(#FFC231, 1.0)'
  showLocation  : true              # set to true to show your current location in the widget

refreshFrequency: 60000            # Update every 10 minutes
#refreshFrequency: 1000            # Update every 10 minutes

style: """
  top  : 115px
  left : 1%
  width: 360px

  font-family: Helvetica Neue
  color      : #{appearance.color}
  text-align : left #center
  background rgba(#000, 0)
  padding 10px 10px 15px
  border-radius 5px
  

  .current .temperature
    font-size  : 42px
    font-weight: 500
    color: #{appearance.accentColor}
    text-shadow: 0 0 4px rgba(#000, 1.5)

  .current .text
    font-size: 12px
    font-weight: 500

  .current .day
    font-size  : 12px
    font-weight: 500
    color: #{appearance.darkerColor}

  .current .location
    font-size  : 12px
    font-weight: 500
    margin-left: 4px
    color: #{appearance.nightColor}

  .forecast .day
    font-size: 10px
    font-weight: 600
    color: #{appearance.darkerColor}

  .forecast .temperatures
    font-size: 12px

  .forecast .temperatures .high
    margin-right: 2px
    font-weight: 500

  .forecast .temperatures .low
    color: #{appearance.nightColor}
    font-weight: 500

  @font-face
    font-family Weather
    src url(SideBar.widget/weather.widget/icons.svg) format('svg')

  icon-size = 120px

  .current
    line-height: 120px
    position: relative
    display: inline-block
    white-space: nowrap
    text-align: left

  .icon
    display: inline-block
    font-family: Weather
    vertical-align: top
    font-size: 80px
    max-height: icon-size
    vertical-align: middle
    text-align: center
    width: icon-size * 1.2
    max-width: icon-size * 1.2

    img
      width: 100%

  .yahoo .icon
    width: icon-size * 1.6
    max-width: icon-size * 1.6

  .details
    display: inline-block
    vertical-align: bottom
    line-height: 1
    text-align: left

  .meta
    margin: 16px 0 12px 0

    .day
      margin-left: 4px

  .yahoo .meta
    left: icon-size * 1.6

  .no-location .location
    display: none

  .forecast
    padding-top 20px
    border-top 1px solid #{appearance.darkerColor}
    font-size: 0
    line-height: 0

    .icon
      font-size: 22px
      line-height: 52px
      max-height: 52px
      max-width: 40px
      vertical-align: middle

      img
        margin-top: 6px
        width: 140%

    .entry
      display: inline-block
      text-align: center
      width: 20%

    .temperatures
      padding: 0
      margin: 0

  .error
    position: absolute
    top: 0
    left: 0
    right: 0
    bottom: 0
    font-size: 20px

    p
      font-size: 14px
"""

command: "#{process.argv[0]} SideBar.widget/weather.widget/get-weather \
                            \"#{options.city}\" \
                            \"#{options.region}\" \
                            #{options.units} \
                            #{'static' if options.staticLocation}"

appearance: appearance


render: -> """
  <div class='current #{@appearance.iconSet} #{ 'no-location' unless @appearance.showLocation }'>
    <li class='icon'></li>
    <div class='details'>
      <div class='today'>
        <span class='temperature'></span>
      </div>
      <div class='txt'>
        <span class='text'></span>
      </div>
      <div class='meta'>
        <span class='day'></span>
        <span class='location'></span>
      </div>
    </div>
  </div>
  <div class='forecast'></div>
"""


update: (output, domEl) ->
  @$domEl = $(domEl)

  data    = JSON.parse(output)
  channel = data?.query?.results?.weather?.rss?.channel
  return @renderError(data) unless channel

  if channel.title == "Yahoo! Weather - Error"
    return @renderError(data, channel.item?.title)

  @renderCurrent channel
  @renderForecast channel

  @$domEl.find('.error').remove()
  @$domEl.children().show()

renderCurrent: (channel) ->
  weather  = channel.item
  location = channel.location
  date     = new Date()

  el = @$domEl.find('.current')
  el.find('.temperature').text "#{Math.round(weather.condition.temp)}°"
  el.find('.text').text @getDutch(weather.condition.code)
  el.find('.day').html @dayMapping[date.getDay()]
  el.find('.location').html location.city # +', '+ location.region
  el.find('.icon').html @getIcon(
    weather.condition.code,
    @appearance.iconSet,
    @getDayOrNight channel.astronomy
  )

renderForecast: (channel) ->
  forecastEl = @$domEl.find('.forecast')
  forecastEl.html ''
  for day in channel.item.forecast[0..4]
    forecastEl.append @renderForecastItem(day, @appearance.iconSet)

renderForecastItem: (data, iconSet) ->
  date = new Date(data.date)
  
  icon = @getIcon(data.code, iconSet, 'd')
  """

    <div class='entry'>
      <div class='day'>#{@dayMapping[date.getDay()]}</div>
      <div class='icon'>#{icon}</div>
      <p class='temperatures'>
        <span class='high'>#{Math.round(data.high)}°</span>
        <span class='low'>#{Math.round(data.low)}°</span>
      </p>
    </div>
  """

renderError: (data, message) ->
  console.error 'weather widget:', data.error if data?.error
  @$domEl.children().hide()

  message ?= """
     Could not retreive weather data for #{data.location}.
      <p>Are you connected to the internet?</p>
  """

  @$domEl.append "<div class=\"error\">#{message}<div>"


# Return either 'd' if the sun is still up, or 'n' if it is gone
getDayOrNight: (data) ->
  now     = new Date()
  sunrise = @parseTime data.sunrise
  sunrise = new Date(
    now.getFullYear(),
    now.getMonth(),
    now.getDate(),
    sunrise.hour,
    sunrise.minute
  ).getTime()

  sunset  = @parseTime data.sunset
  sunset  = new Date(
    now.getFullYear(),
    now.getMonth(),
    now.getDate(),
    sunset.hour,
    sunset.minute
  ).getTime()

  now = now.getTime()

  if now > sunrise and now < sunset then 'd' else 'n'

# parses a time string in US format: hh:mm am|pm
parseTime: (usTimeString) ->
  parts = usTimeString.match(/(\d+):(\d+) (\w+)/)

  hour   = Number(parts[1])
  minute = Number(parts[2])
  am_pm  = parts[3].toLowerCase()

  hour += 12 if am_pm == 'pm'

  hour: hour, minute: minute

getDutch: (code) ->
	@LanguageMapping[code]

getIcon: (code, iconSet, dayOrNight) ->
  if code == '3200' then code = '31'   # 3200 heeft geen image
  
  if iconSet is 'yahoo'
    @getYahooIcon(code, dayOrNight)
  else
    @getOriginalIcon(code)

getOriginalIcon: (code) ->
  return @iconMapping['unknown'] unless code
  @iconMapping[code]

getYahooIcon: (code, dayOrNight) ->
  # Returns the image element from Yahoo with the proper image
  imageURL = "http://l.yimg.com/a/i/us/nws/weather/gr/#{code}#{dayOrNight}.png"
  '<img src="' + imageURL + '">'

dayMapping:
  0: 'Zondag'
  1: 'Maandag'
  2: 'Dinsdag'
  3: 'Woensdag'
  4: 'Donderdag'
  5: 'Vrijdag'
  6: 'Zaterdag'

LanguageMapping:
  0    : "Tornado" # tornado
  1    : "Tropische storm" # tropical storm
  2    : "Orkaan" # hurricane
  3    : "Zware onweersbuien" # severe thunderstorms
  4    : "Onweersbuien" # thunderstorms
  5    : "Gemengde regen en sneeuw" # mixed rain and snow
  6    : "Gemengde regen en ijzel" # mixed rain and sleet
  7    : "Gemengde regen en sneeuw" # mixed snow and sleet
  8    : "Ijskoude motregen" # freezing drizzle
  9    : "Motregen" # drizzle
  10   : "Ijskoude regen" # freezing rain
  11   : "Harde regen" # showers
  12   : "Harde regen" # showers
  13   : "Sneeuwvlagen" # snow flurries
  14   : "Lichte sneeuwbuien" # light snow showers
  15   : "Sneeuwbuien" # blowing snow
  16   : "Sneeuw" # snow
  17   : "Hagel" # hail
  18   : "Ijzel" # sleet
  19   : "stof" # dust
  20   : "Lichte mist" # foggy
  21   : "Middelmatige mist" # haze
  22   : "Zware mist" # smoky
  23   : "Dikke mist" # blustery
  24   : "Winderig" # windy
  25   : "Koud" # cold
  26   : "Bewolkt" # cloudy
  27   : "Overwegend bewolkt" # mostly cloudy (night)
  28   : "Overwegend bewolkt" # mostly cloudy (day)
  29   : "Gedeeltelijk bewolkt" # partly cloudy (night)
  30   : "Gedeeltelijk bewolkt" # partly cloudy (day)
  31   : "Helder" # clear (night)
  32   : "Zonnig" # sunny
  33   : "Matig" # fair (night)
  34   : "Matig" # fair (day)
  35   : "Gemengde regen en hagel" # mixed rain and hail
  36   : "Bloedheet" # hot
  37   : "Geïsoleerde onweersbuien" # isolated thunderstorms
  38   : "Verspreide onweersbuien" # scattered thunderstorms
  39   : "Verspreide onweersbuien" # scattered thunderstorms
  40   : "Verspreide regenbuien" # scattered showers
  41   : "Zware sneeuwbuien" # heavy snow
  42   : "Verspreide sneeuwbuien" # scattered snow showers
  43   : "Zware sneeuwbuien" # heavy snow
  44   : "Gedeeltelijk bewolkt" # partly cloudy
  45   : "Onweersbuien" # thundershowers
  46   : "Sneeuwbuien" # snow showers
  47   : "Geïsoleerde regenbuien" # isolated thundershowers
  3200 : "Geen weer" # not available

iconMapping:
  0    : "&#xf021;" # tornado
  1    : "&#xf021;" # tropical storm
  2    : "&#xf021;" # hurricane
  3    : "&#xf019;" # severe thunderstorms
  4    : "&#xf019;" # thunderstorms
  5    : "&#xf019;" # mixed rain and snow
  6    : "&#xf019;" # mixed rain and sleet
  7    : "&#xf019;" # mixed snow and sleet
  8    : "&#xf019;" # freezing drizzle
  9    : "&#xf019;" # drizzle
  10   : "&#xf019;" # freezing rain
  11   : "&#xf019;" # showers
  12   : "&#xf019;" # showers
  13   : "&#xf01b;" # snow flurries
  14   : "&#xf01b;" # light snow showers
  15   : "&#xf01b;" # blowing snow
  16   : "&#xf01b;" # snow
  17   : "&#xf019;" # hail
  18   : "&#xf019;" # sleet
  19   : "&#xf002;" # dust
  20   : "&#xf014;" # foggy
  21   : "&#xf014;" # haze
  22   : "&#xf014;" # smoky
  23   : "&#xf021;" # blustery
  24   : "&#xf021;" # windy
  25   : "&#xf021;" # cold
  26   : "&#xf013;" # cloudy
  27   : "&#xf031;" # mostly cloudy (night)
  28   : "&#xf002;" # mostly cloudy (day)
  29   : "&#xf031;" # partly cloudy (night)
  30   : "&#xf002;" # partly cloudy (day)
  31   : "&#xf02e;" # clear (night)
  32   : "&#xf00d;" # sunny
  33   : "&#xf031;" # fair (night)
  34   : "&#xf00c;" # fair (day)
  35   : "&#xf019;" # mixed rain and hail
  36   : "&#xf00d;" # hot
  37   : "&#xf019;" # isolated thunderstorms
  38   : "&#xf019;" # scattered thunderstorms
  39   : "&#xf019;" # scattered thunderstorms
  40   : "&#xf019;" # scattered showers
  41   : "&#xf01b;" # heavy snow
  42   : "&#xf01b;" # scattered snow showers
  43   : "&#xf01b;" # heavy snow
  44   : "&#xf00c;" # partly cloudy
  45   : "&#xf019;" # thundershowers
  46   : "&#xf00c;" # snow showers
  47   : "&#xf019;" # isolated thundershowers
  3200 : "&#xf00c;" # not available


