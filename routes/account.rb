# routes/accounts.rb
require_relative '../models/account'

get '/accounts' do
  auth_check do |user|
    if user.admin?
      Account.all.to_json
    else
      halt 403, { access: :denied }.to_json
    end
  end
end
