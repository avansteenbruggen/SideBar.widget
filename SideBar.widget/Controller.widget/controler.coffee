refreshFrequency: 5000000 
style: """
    background: rgba(#000, 0.0)
    color: rgba(#fff, 0.7) 
    font-size:12px
    font-family: Helvetica Neue
    padding 10px 10px 15px
    left: 0%
    bottom: 0%

	.AdBackGround
      width: 370px
      height: 10%


    #iAnalogClock
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff

    #iIP
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff

    #iDigitalClock
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff

    #iStats
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff

    #iBatteryCharge
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff

    #iWeather
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff

    #iTunesMiniPlayer
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff
      
    #iDisk-usage
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff
      
    #iWallpaper
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff
      
    #iCpu
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff

    #iMem
      display: inline-block
      width: 10px
      height: 10px
      border-radius 5px
      background: #fff
"""

render: -> """
  <div class='AdBackGround'>
  	<div class='buttons'>
  		<table>
  		<tr>
	  		<td class='button1'>
	  			<span id='iAnalogClock'></span>
	  			<span id='iAnalogClocktxt'>Analog</span>
	  		</td>
	  		<td class='button2'>
	  			<span id='iIP'></span>
	  			<span id='iIPtxt'>IP</span>
	  		</td>
	  		<td class='button3'>
	 	 		<span id='iDigitalClock'></span>
	 	 		<span id='iDigitalClocktxt'>Digital</span>
	 	 	</td>
		  	<td class='button4'>
		  		<span id='iStats'></span>
		  		<span id='iStatstxt'>iStats</span>
		  	</td>
	  	</tr>
  		<tr>
		  	<td class='button5'>
		  		<span id='iBatteryCharge'></span>
		  		<span id='iBatteryChargetxt'>Battery</span>
		  	</td>
		  	<td class='button6'>
		  		<span id='iWeather'></span>
		  		<span id='iWeathertxt'>Weather</span>
		  	</td>
		  	<td class='button7'>
		  		<span id='iTunesMiniPlayer'></span>
		  		<span id='iTunesMiniPlayertxt'>iTunes</span>
		  	</td>
		  	<td class='button8'>
		  		<span id='iDisk-usage'></span>
		  		<span id='iDisk-usagetxt'>Disk</span>
		  	</td>
	  	</tr>
  		<tr>
		  	<td class='button9'>
			  	<span id='iWallpaper'></span>
			  	<span id='iWallpapertxt'>Wallpaper</span>
		  	</td>
		  	<td class='button10'>
		  		<span id='iCpu'></span>
		  		<span id='iCputxt'>Cpu</span>
		  	</td>
		  	<td class='button11'>
		  		<span id='iMem'></span>
		  		<span id='iMemtxt'>Mem</span>
		  	</td>
	  	</tr>
	  	</table>
  	</div>
  </div>
"""

command: " "

afterRender: (domEl) ->
    $(domEl).on 'click', '#iAnalogClock', => @run "osascript 'SideBar.widget/AnalogClock.widget/OnOff.scpt'"
    $(domEl).on 'click', '#iIP', => @run "osascript 'SideBar.widget/public_ip.widget/OnOff.scpt'"
    $(domEl).on 'click', '#iDigitalClock', => @run "osascript 'SideBar.widget/fancy-datetime.widget/OnOff.scpt'"
    $(domEl).on 'click', '#iStats', => @run "osascript 'SideBar.widget/istats.widget/OnOff.scpt'"
    $(domEl).on 'click', '#iBatteryCharge', => @run "osascript 'SideBar.widget/BatteryCharge.widget/OnOff.scpt'"
    $(domEl).on 'click', '#iWeather', => @run "osascript 'SideBar.widget/weather.widget/OnOff.scpt'"
    $(domEl).on 'click', '#iTunesMiniPlayer', => @run "osascript 'SideBar.widget/iTunesMiniPlayer.widget/OnOff.scpt'"
    $(domEl).on 'click', '#iDisk-usage', => @run "osascript 'SideBar.widget/disk-usage.widget/OnOff.scpt'"
    $(domEl).on 'click', '#iWallpaper', => @run "osascript 'SideBar.widget/wallpaper.widget/OnOff.scpt'"
    $(domEl).on 'click', '#iCpu', => @run "osascript 'SideBar.widget/top-cpu.widget/OnOff.scpt'"
    $(domEl).on 'click', '#iMem', => @run "osascript 'SideBar.widget/top-mem.widget/OnOff.scpt'"

update: (output,domEl) ->
	#iTunesvalues = output.split('~')
	
    $(domEl).find("#iAnalogClock").html("")

