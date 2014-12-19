#require 'bcrypt'
class SessionsController < ApplicationController
	NOT_EXISTS = "Username/password did not match"

	def new
		render :index
	end

	def create
		user = Users.where(:username => params[:sessions][:username]).first
		unless user.nil?
			if user.password == compute
			#if BCrypt::Password.new(user.password) == params[:sessions][:password]
				render :text => "Login Successfully"
			else
				render :text => NOT_EXISTS
			end
		else
			render :text => NOT_EXISTS
		end
	end

	private
	def compute
		100000000.times do;end
	end
end
