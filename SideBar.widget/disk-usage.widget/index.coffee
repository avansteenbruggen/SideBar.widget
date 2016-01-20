# You may exclude certain drives (separate with a pipe)
# Example: exclude = 'MyBook' or exclude = 'MyBook|WD Passport'
# Set as something obscure to show all drives (strange, but easier than editing the command)
exclude   = 'NONE'

# Use base 10 numbers, i.e. 1GB = 1000MB. Leave this true to show disk sizes as
# OS X would (since Snow Leopard)
base10       = true

# appearance
filledStyle  = true # set to true for the second style variant. bgColor will become the text color

width        = '350px'
barHeight    = '20px'
labelColor   = 'rgba(248, 106, 36, 1)'
usedColor    =  'rgba(73,109,73,.8)' 
freeColor    = '#fff' 
totalColor   = 'rgba(192,192,192,.5)'
 
freeTxtColor = '#fff' 
usedTxtColor = '#000' 

bgColor      = '#fff'
borderRadius = '3px'

bgOpacity    = 1.0

# You may optionally limit the number of disk to show
maxDisks: 10


command: "df -#{if base10 then 'H' else 'h'} | grep '/dev/' | while read -r line; do fs=$(echo $line | awk '{print $1}'); name=$(diskutil info $fs | grep 'Volume Name' | awk '{print substr($0, index($0,$3))}'); echo $(echo $line | awk '{print $2, $3, $4, $5}') $(echo $name | awk '{print substr($0, index($0,$1))}'); done | grep -vE '#{exclude}'"

refreshFrequency: 60000

style: """
  top: 590px
  left: 20px
  font-family: Helvetica Neue
  font-weight: 500

  .label
    font-size: 12px
    color: rgba(#{labelColor}, 0.8)
    margin-left: 1px
    font-style: italic
    font-family: Myriad Set Pro, Helvetica Neue

    .total
      display: inline-block
      color:#{if filledStyle then totalColor else labelColor}
      margin-left: 8px
      font-weight: bold
      text-align:right

  .disk:not(:first-child)
    margin-top: 1px

  .wrapper
    height: #{barHeight}
    font-size: #{Math.round(parseInt(barHeight)*1.5)}px
    line-height: 1
    width: #{width}
    max-width: #{width}
    margin: 1px 0 0 0
    position: relative
    overflow: hidden
    border-radius: #{borderRadius}
    background: rgba(#{bgColor}, #{bgOpacity})
    #{'background: none' if filledStyle }

  .wrapper:first-of-type
    margin: 0px

  .bar
    position: absolute
    top: 0
    bottom: 0px

    &.used
      border-radius: #{borderRadius} 0 0 #{borderRadius}
      background: rgba(#{usedColor}, #{ if filledStyle then bgOpacity else 0.9 })
      border-bottom: 1px solid #{usedColor}
      #{'border-bottom: none' if filledStyle }

    &.free
      right: 0
      border-radius: 0 #{borderRadius} #{borderRadius} 0
      background: rgba(#{freeColor}, #{0.6})
      border-bottom:  1px solid #{freeColor}
      #{'border-bottom: none' if filledStyle }


  .stats
    display: inline-block
    font-size: 0.5em
    line-height: 1
    word-spacing: -2px
    text-overflow: ellipsis
    vertical-align: middle
    position: relative

    span
      font-size: 0.8em
      margin-left: 2px

    .free, .used
      display: inline-block
      white-space: nowrap

    .free
      margin-left: 12px
      margin-bottom: 16px
      color: #{if filledStyle then freeTxtColor else freeColor}
	  
    .used
      color: #{if filledStyle then usedTxtColor else totalColor}
      margin-left: 6px
      font-size: 0.9em
      
  .needle
    width: 0
    border-left: 1px dashed rgba(#{usedColor}, 0.2)
    position: absolute
    top: 0
    bottom: -2px
    display: #{'none' if filledStyle}

    &:after, &:before
      content: ' '
      border-top: 5px solid #{totalColor}
      border-left: 4px solid transparent
      border-right: 4px solid transparent
      position: absolute
      left: -4px
"""

humanize: (sizeString) ->
  sizeString + 'B'


renderInfo: (total, used, free, pctg, name) -> """
  <div class='disk'>
    <div class='label'>#{name} <span class='total'>#{@humanize(total)}</span></div>
    <div class='wrapper'>
      <div class='bar used' style='width: #{pctg}'></div>
      <div class='bar free' style='width: #{100 - parseInt(pctg)}%'></div>

      <div class='stats'>
        <div class='free'>#{@humanize(free)} <span>free</span> </div>
        <div class='used'>#{@humanize(used)} <span>used</span></div>
      </div>
      <div class='needle' style="left: #{pctg}"></div>
    </div>
  </div>
"""

update: (output, domEl) ->
  disks = output.split('\n')
  $(domEl).html ''

  for disk, i in disks[..(@maxDisks - 1)]
    args = disk.split(' ')
    if (args[4])
      args[4] = args[4..].join(' ')
      $(domEl).append @renderInfo(args...)
