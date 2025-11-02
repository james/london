class ApplicationController < ActionController::Base
	before_action :http_basic_auth

	private

	def http_basic_auth
		return if request.path == '/up'
		username = ENV['BASIC_AUTH_USERNAME']
		password = ENV['BASIC_AUTH_PASSWORD']

		return unless username.present? && password.present?

		authenticate_or_request_with_http_basic('Restricted') do |u, p|
			u == username && p == password
		end
	end
end
