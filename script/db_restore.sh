read -p "Are you sure? (y/n) : " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  rake db:drop db:create
  curl -o latest.dump `heroku pgbackups:url --app mercer-inpharmd`
  pg_restore --verbose --clean --no-acl --no-owner -h localhost -p 5432 -d mercer-inpharmd_development latest.dump
  rake db:migrate
  rm latest.dump
fi