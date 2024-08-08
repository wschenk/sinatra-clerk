# app.rb
require 'dotenv/load'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'routes/posts'
require 'jwt'
require 'clerk'

# For cookies
use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           secret: 'sosecret'

set :default_content_type, :json

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Allow-Methods'] =
    'GET, POST, PUT, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] =
    'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
end

options '*' do
  response.headers['Allow'] = 'GET, POST, PUT, DELETE, OPTIONS'
  200
end

get '/' do
  { message: 'Hello world.' }.to_json
end

get '/up' do
  { success: true }.to_json
end

get '/private' do
  auth_check do
    { message: 'This is a private message.' }.to_json
  end
end

def auth_check
  # clerk = Clerk::SDK.new(api_key: ENV.fetch('CLERK_SECRET_KEY', nil))

  token = extract_token_from_header

  if token
    begin
      decoded_token = Clerk::SDK.new.verify_token(token)
      puts decoded_token
      user_id = decoded_token['sub']
      puts "Valid JWT token found for user_id: #{user_id}"
      return yield
    rescue JWT::DecodeError
      puts 'Invalid JWT token'
    end
  end

  return yield if session[:account_id]

  halt 403, { access: :denied }.to_json
end

def extract_token_from_header
  auth_header = request.env['HTTP_AUTHORIZATION']
  auth_header&.start_with?('Bearer ') ? auth_header.split(' ').last : nil
end
