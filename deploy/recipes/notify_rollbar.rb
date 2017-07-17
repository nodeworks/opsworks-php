#
# Cookbook Name:: deploy
# Recipe:: readycart
#

execute "Notify rollbar of deployment" do
  command "cd /srv/www/readycart/current && curl https://api.rollbar.com/api/1/deploy/ -F access_token=7ac65697d0964dd9834a222341209467 -F environment=#{node[:deploy][:readycart][:scm][:revision]} -F revision=$(git log -n 1 --pretty=format:%H) -F local_username=\"$(git log -n 1 --pretty=format:%an)\" -F comment=\"$(git log -n 1 --pretty=format:%s)\" > /dev/null"
  action :run
end
