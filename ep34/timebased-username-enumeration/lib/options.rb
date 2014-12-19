require 'optparse'
class Options
  attr_reader :valid_username,
              :request_count,
              :method,
              :input_file,
              :query_data,
              :uri,
              :cookies,
              :paddr,
              :pport

  attr_accessor :margin

  # Parse arguments provided as a HASH
  def parse(args)
    OptionParser.new do |opts|
      opts.banner = "Usage: enumerate.rb [options]"

      # Valid username for comparison
      opts.on("-u", "--validuser [USER]", "Valid username for comparison") do |user|
      	@valid_username = user
      end

      opts.on("-f", "--input-file [FILEPATH]", "Path to dictionary file" + 
        "containing usernames") do |filepath|
      	@input_file = filepath
      end

      # Defaults to 10
      opts.on("-c", "--request-count [COUNT]", "Number of requests to send before" + 
        "making a decision. Defaults to 10") do |count|
      	@request_count = count
      end
      opts.on("-d", "--query-data [DATA]", "HTTP data to send") do |data|
        @query_data = data
      end

      opts.on("-x", "--uri [URI]", "Request URI") do |uri|
        @uri = uri
      end

      # Defaults to POST
      opts.on("--method [METHOD]", "HTTP request method") do |method|
        @method = method
      end

      opts.on("--margin [MARGIN]", "Time margin for determining successful exploitation (Defaults to 50ms)") do |margin|
        @margin = margin
      end

      opts.on("--cookies [COOKIES]", "HTTP Cookies to use in request") do |cookies|
        @cookies = cookies
      end

      opts.on("--proxy-address [PADDR]", "Proxy Address") do |proxy_addr|
        @paddr = proxy_addr
      end

      opts.on("--proxy-port [PPORT]", "Proxy Port") do |proxy_port|
        @pport = proxy_port
      end

    end.parse!
  end

  # Make sure we have at least the HTTP Request
  def valid?
    if @uri.nil? || @query_data.nil?
      return false
    end
    true
  end
end