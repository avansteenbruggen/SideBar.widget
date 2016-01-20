
# Set the refresh 2 minutes.
#refreshFrequency: 120000
# Set the refresh 5 minutes.
refreshFrequency: 300000



#org width en height = 350x218
#org left =20

style: """
	bottom:7%
	left: 390px
	color: #fff

	
	#button 
		width: 10px
		height: 10px
		border-radius: 5px			
		background: rgba(#fff, 0.5)
		
	.album 
		width: 700px
		height: 436px
		text-align: center
		border: 0px solid #000
		background: rgba(#000, 0.5)
		
	#albm
	    -webkit-backdrop-filter: blur(10px)
		
	.image
		border-radius: 10px			
	
"""

render: -> """
<div class='cover' id='covr'></div>
"""

command: "osascript 'SideBar.widget/Wallpaper.widget/getwallpaper.scpt'"
 
afterRender: (domEl) ->
    $(domEl).on 'click', '#button', => @refresh()
 
    
# Update the rendered output.
update: (output, domEl) ->
	mydiv = $(domEl).find('div')
	
	html = ''
	html += "<div id='button'></div>"
	html += "<div class='album' id=albm>"
	html += "<img style='height: 100%' src='../SideBar.widget/Wallpaper.widget/image/"
	html += output
	html += "' align='middle' class='image'>"
	html += "</div>"
	
	# Set the output
	mydiv.html(html)



