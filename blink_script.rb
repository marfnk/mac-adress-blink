require 'rubygems'
require 'bundler/setup'
require 'arp_scan'
require 'blink1'
require 'pry'

#Settings 
@network_adapter = 'en0'
#assign color to mac adresses
@persons_of_interest = {'f8:a9:d0:0c:7e:7c' => [255,0,0], 'f8:95:c7:f6:95:75' => [0,255,0], 'c0:ee:fb:4a:40:e5' => [0,0,255]}
#or scan for any new device
@scan_all = false
#sleep time between polls (and notification time) in seconds
@scan_interval = 10

def main
	@online = []
	iteration = 0;
	
	#start scanning
	while (true) do
		Blink1.open do |blink1|
		  blink1.off
		end

		report = ARPScan("--localnet --interface=#{@network_adapter}")
		result = analyse_hosts(report.hosts)

		iteration += 1
		puts "#{iteration}. Sleeping for (#{@scan_interval}s). (#{result[:online_interesting].size} monitored hosts online)"
		sleep @scan_interval if result[:new_hosts].empty?
	end

end

def analyse_hosts(hosts)
	#create an array with only the mac adresses
	online_unfiltered = hosts.map {|host| host.mac}

	#intersection of online hosts and ting hosts
	online_interesting = @scan_all ? online_unfiltered.keys : online_unfiltered & @persons_of_interest.keys

	#online interesting without already online hosts
	new_hosts = online_interesting - @online
	blink_for_new_hosts(new_hosts) unless new_hosts.empty?
	
	#gone hosts are cached hosts without current online hosts
	gone_hosts = @online - online_interesting
	greet_gone_hosts(gone_hosts)

	#save something like {mac => timestamp}
	@online = online_interesting #.inject({}) {|hsh, mac| hsh[mac] = Time.now.to_i; hsh}
	{new_hosts: new_hosts, gone_hosts: gone_hosts, online_unfiltered: online_unfiltered, online_interesting: online_interesting}
end

def blink_for_new_hosts(new_hosts) 
	blink1 = Blink1.new
	blink1.open
	
	times = [@scan_interval * 1000 / 1600 / new_hosts.length, 2].max
	new_hosts.each_with_index do |host, i|
		puts "Welcome, #{host}!"
		blink1.blink(getColorForHost(host, :red),getColorForHost(host, :green),getColorForHost(host, :blue),times)
	end
	
	blink1.close
end

def greet_gone_hosts(gone_hosts)
	gone_hosts.each do |host|
		puts "Goodbye, #{host}!"
	end
end

def getColorForHost(host, color)
	color_positions = {red: 0, green: 1, blue: 2}
	@persons_of_interest[host] ? @persons_of_interest[host][color_positions[color]] : 255
end


#run the main method
main
