# mac-adress-blink(1)
This project is a submission to the [eSailors](http://esailors.de/en/) contest from [code.talks 2015](https://www.codetalks.de/).

## Description
This project contains a Ruby script that performs [ARP-Scans](http://www.nta-monitor.com/wiki/index.php/Arp-scan_User_Guide) in your local network which retrieves the currently logged-in devices.

You can specify mac adresses that will be surveilled. If this devices logs in, a [blink(1)](https://blink1.thingm.com/) blinks in a specified color.

https://youtu.be/

<a href="http://www.youtube.com/watch?feature=player_embedded&v=bEWEiN0M0y8" target="_blank"><img src="http://img.youtube.com/vi/bEWEiN0M0y8/0.jpg" 
alt="YouTube Video" width="240" height="180" border="1" /></a>

### Sample use cases
1. Get a notice whenever your boss is entering the office. Simply find out his iPhone's mac adress, configure the script and run it (e.g. on a Rasperry PI on your desk). You know it's time to look busy when the light goes on!
2. Be warned just before your roommate comes home. Her/his phone will connect to your wifi a few meters (or levels) before the door so you might just have enough time to turn out his/her PlayStation ;)
3. As a teacher I want to scan for all devices in my classroom during tests so I know when someone is cheating. This is possible with the option `scan_for_all = true` 

## User manual
Start by cloning this repo.

### Setup dependencies
Install arp-scan with

`$ sudo apt-get install arp-scan`
for Ubuntu or

`$ brew install arp-scan` for Mac OSX (with [Homebrew](http://brew.sh/))

### Configuration
open `blink_script.rb` with a text editor for configuration

    #set your network adapter (find it with '$ ifconfig') 
    @network_adapter = 'en0'
	
insert your mac adresses:

    #assign rgb-color to mac adresses
	@persons_of_interest = {'e7:a9:ea:0c:6f:6d' => [255,0,0], 'f5:a6:7b:5c:e2:d0' => [0,255,255]}
	#... or ignore interesting mac adresses and scan for any new device
	@scan_all = true
	
also adjust the polling interval

	#sleep time between polls in seconds
	@scan_interval = 10

### Run!
1. `$ bundle install` the dependencies
2. attach your blink(1)
3. `$ sudo ruby blink_script.rb` to run it<br/>
   *Yes, you have to run it with root privileges because it needs access to your network cards.*