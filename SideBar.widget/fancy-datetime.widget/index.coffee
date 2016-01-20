###
----------------------------------------------------------------

    Fancy DateTime - v1.0.0

    Uebersicht-widget for displaying the current time and date


    Robin 'codeFareith' von den Bergen
    robinvonberg@gmx.de
    https://github.com/codefareith

----------------------------------------------------------------
###

# Widget Settings
settings =
    lang: 'nl'
    militaryTime: true
    colors:
      default: 'rgba(255, 255, 255, 1.75)'
      accent: 'rgba(248, 106, 36, 1.75)'
      background: 'rgba(255, 255, 255, 0)'
    shadows:
      box: '0 0 1.25em rgba(0, 0, 0, 0)'
      text: '0 0 0.625em rgba(0, 0, 0, 1)'

# Locale Strings
locale =
  en:
    weekdays: [
      'Sunday'
      'Monday'
      'Tuesday'
      'Wednesday'
      'Thursday'
      'Friday'
      'Saturday'
    ]
    months: [
      'January'
      'February'
      'March'
      'April'
      'May'
      'June'
      'July'
      'August'
      'September'
      'October'
      'November'
      'December'
    ]
  nl:
    weekdays: [
      'Zondag'
      'Maandag'
      'Dinsdag'
      'Woensdag'
      'Donderdag'
      'Vrijdag'
      'Zaterdag'
    ]
    months: [
      'Januari'
      'Februari'
      'Maart'
      'April'
      'Mei'
      'Juni'
      'Juli'
      'Augustus'
      'September'
      'October'
      'November'
      'December'
    ]

command: ""

settings: settings
locale: locale

refreshFrequency: 1000

style: """
  top: 10px
  left: 165px
  font-family: 'Ubuntu', sans-serif
  font-size: 16px
  line-height: 1
  text-transform: uppercase

  .container
    position: relative
    display: table
    height: 100%
    width: 180px
    padding: 0rem 1rem
    border-radius: 1rem
    background: #{ @settings.colors.background }
    box-shadow: #{ @settings.shadows.box }
    text-shadow: #{ @settings.shadows.text }
    overflow: hidden

  .container2
    position: relative
    display: table
    height: 100%
    width: 180px
    padding: 0rem 1rem
    border-radius: 1rem
    background: #{ @settings.colors.background }
    box-shadow: #{ @settings.shadows.box }
    text-shadow: #{ @settings.shadows.text }
    overflow: hidden


  .left
    float: left

  .txt-default
    color: #{ @settings.colors.default }

  .txt-accent
    color: #{ @settings.colors.accent }

  .txt-small
    text-align: center
    font-size: 0.8rem
    font-weight: 500

  .txt-large
    font-size: 4.0rem
    font-weight: 700

  .txt-div
    font-size: 3.0rem
    font-weight: 100

  .txt-time
    text-align: center

"""

render: () -> """
  <div class='container'>
    <div class='cell txt-time'>
      <span class='hours txt-default txt-large'></span>
      <span class='dev txt-default txt-div'></span>
      <span class='minutes txt-accent txt-large'></span>
      <span class='suffix txt-default txt-small'></span>
    </div>
  </div>
  <div class='container2'>
    <div class='cell2 txt-small'>
      <span class='weekday txt-accent'></span>
      <div class='txt-default'>
        <span class='day'></span>
        <span class='month'></span>
      </div>
      <span class='year txt-accent'></span>
    </div>
  </div>
"""

afterRender: (domEl) ->

update: (output, domEl) ->
  date = @getDate()

  $(domEl).find('.hours').text(date.hours)
  $(domEl).find('.dev').text(":")
  $(domEl).find('.minutes').text(date.minutes)
  $(domEl).find('.suffix').text(date.suffix)
  $(domEl).find('.weekday').text(date.weekday)
  $(domEl).find('.day').text(date.day)
  $(domEl).find('.month').text(date.month)
  $(domEl).find('.year').text(date.year)

# Helper-Functions
zeroFill: (value) ->
  return ('0' + value).slice(-2)

getDate: () ->
  date = new Date()
  hour = date.getHours()

  suffix = (if (hour >= 12) then 'pm' else 'am') if (@settings.militaryTime is false)
  hour = (hour % 12 || 12) if (@settings.militaryTime is false)

  hours = @zeroFill(hour);
  minutes = @zeroFill(date.getMinutes())
  seconds = @zeroFill(date.getSeconds())
  weekday = @locale[@settings.lang].weekdays[date.getDay()]
  day = @zeroFill(date.getDate())
  month = @locale[@settings.lang].months[date.getMonth()]
  year = date.getFullYear()

  return {
    suffix: suffix
    hours: hours
    minutes: minutes
    seconds: seconds
    weekday: weekday
    day: day
    month: month
    year: year
  }