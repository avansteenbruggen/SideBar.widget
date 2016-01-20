command: "curl -4fNs ip.appspot.com"

refreshFrequency: 43200000

style: """
  top: 350px
  left: 252px
  color: rgba(248, 106, 36, 1)
  font-family: Helvetica Neue

  div
    display: block
    border: 0px solid #fff
    text-shadow: 0 0 4px rgba(#000, 1.5)
    background: rgba(#fff, 0.0)
    font-size: 16px
    font-weight: 500
    padding: 4px 6px 4px 6px


"""


render: -> """
  <div class='ip_address'></div>
"""

update: (output, domEl) ->
  $(domEl).find('.ip_address').html(output)

