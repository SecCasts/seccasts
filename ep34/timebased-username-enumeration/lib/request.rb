require 'net/http'
require 'uri'

# Handles the network stuff, including request timing
class Request
	def initialize(username, opts)
		@username = username
		@opts = opts
	end

	def execute()
	# Let's see if we're using ssl
	if @opts.uri.match(/(https:\/\/)/)
		use_ssl = true
	end

	# Use cookies if we have them
	cookies = ""
	if @opts.cookies
		cookies = @opts.cookies
	end

	# Find username parameter and replace
	data = replace_username(@opts.query_data, @username)
	uri = @opts.uri

	 if @opts.method == "POST" 
	 	# Split data into hash
	 	tmp_uri = URI(@opts.uri + "/?" + data)
	 	data = Hash[URI::decode_www_form(tmp_uri.query)]

	 	uri = URI.parse(uri)
	 	http = Net::HTTP.new(uri.host, uri.port, @opts.paddr, @opts.pport)

	 	if use_ssl
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		end

		request = Net::HTTP::Post.new(uri.request_uri)
		request.set_form_data(data)
		request['Cookie'] = cookies

	 	start_time = Time.now
	 	response = http.request(request)
	 	end_time = Time.now
	 else
	 	uri = @opts.uri + "/?" + data
	 	uri = URI(uri)

	 	http = Net::HTTP.new(uri.host, uri.port)

	 	if use_ssl
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		end
		request = Net::HTTP::Get.new(uri.request_uri)
		request['Cookie'] = cookies

	 	start_time = Time.now
	 	response = http.request(request)
	 	end_time = Time.now
	 end
	 { :response_obj => response, :response_time => get_elapsed_ms(start_time, end_time)}
	end

	def get_elapsed_ms(time1, time2)
		(time2 - time1) * 1000
	end

	def replace_username(data,  username)
		data = data.gsub("PARAM", username)
		return data
	end
end