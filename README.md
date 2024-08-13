# sinatra-clerk

See https://github.com/wschenk/sinatra-ar-template

op inject -i secrets.env -o .env

rake db:migrate

rake dev

accounts table will be synced with the clerk remote user once
auth_user passes
