command: "ps axo \"rss,pid,ucomm\" | sort -nr | tail +1 | head -n3 | awk '{printf \"%8.0f MB,%s,%s\\n\", $1/1024, $3, $2}'"

refreshFrequency: 5000

style: """
  top: 490px
  left: 303px
  color: #fff
  font-family: Helvetica Neue


  table
    border-collapse: collapse
    table-layout: fixed

    &:before
      content: 'mem'
      position: absolute
      right: 0
      top: -14px
      font-size: 10px

  td
    border: 1px solid #fff
    font-size: 16px
    font-weight: 300
    width: 70px
    max-width: 70px
    text-shadow: 0 0 1px rgba(#000, 0.5)
    text-align:right

  .wrapper
    padding: 0px 2px 0px 2px
    position: relative

  .col1
    color:rgba(248, 106, 36, 1)
    background: rgba(#fff, 0.2)

  .col2
    color:rgba(248, 106, 36, 1)
    background: rgba(#fff, 0.1)

  .col3
    color:rgba(248, 106, 36, 1)
    background: rgba(#fff, 0.0)

  p
    padding: 0
    margin: 0
    font-size: 9px
    font-weight: bold
    max-width: 100%
    color: #ddd
    white-space: nowrap
    overflow: ellipsis
    text-shadow: none

  .pid
    position: absolute
    top: 2px
    right: 2px
    font-size: 10px
    font-weight: normal

"""


render: ->
  """
  <div>
  <table>
    <tr>
      <td class='col1'></td>
    </tr>
  </table>
  </div>
  <div>
  <table>
    <tr>
      <td class='col2'></td>
    </tr>
  </table>
  </div>
  <div>
  <table>
    <tr>
      <td class='col3'></td>
    </tr>
  </table>
  </div>
"""

update: (output, domEl) ->
  processes = output.split('\n')
  table     = $(domEl).find('table')

  renderProcess = (cpu, name, id) ->
    "<div class='wrapper'>" +
      "#{cpu}<p>#{name}</p>" +
    "</div>"

  for process, i in processes
    args = process.split(',')
    table.find(".col#{i+1}").html renderProcess(args...)

