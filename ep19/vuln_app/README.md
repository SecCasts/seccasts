To get started...


Install the gems

    bundle install

Get the DB setup

    rake db:setup

Make recaptcha keys for the domain `localhost`, place those keys inside config/initializers/recaptcha.rb

    Recaptcha.configure do |config|

	    config.public_key = 'insert your publick key here'
	    config.private_key = 'insert your private key here'

	end

Start the application

    rails s
