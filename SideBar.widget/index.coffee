refreshFrequency: 5000000 

style: """

    background: rgba(#000, 0.5)
    color: rgba(#fff, 0.7) 
    font-size:12px
    font-family: Helvetica Neue
    padding 10px 10px 15px
    -webkit-backdrop-filter: blur(10px)
    top: 0%
    left: 0%
    bottom: 0%

	.AdBackGround
      width: 370px
      height: 100%


"""

render: (output) -> """
  <div class='AdBackGround'>
  </div>
"""

command: " "


update: (output,domEl) ->
	
  	$(domEl).html #output