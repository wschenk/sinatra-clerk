# routes/posts.rb
require_relative '../models/post'

get '/posts' do
  Post.all.to_json
end

post '/posts' do
  auth_check do
    p = Post.new(name: params[:name], body: params[:body])
    if p.save
      p.to_json
    else
      p.errors.to_json
    end
  end
end
