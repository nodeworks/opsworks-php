app = search(:aws_opsworks_app).first
app_path = "/var/www/" + app['attributes']['document_root']

# deploy git repo from opsworks app
application app_path do
  owner 'www-data'
  group 'www-data'

  git app_path do
    user 'www-data'
    group 'www-data'
    repository app['app_source']['url']
    deploy_key app['app_source']['ssh_key']
  end
end

# update nginx with the drupal site
template "/etc/nginx/sites-enabled/#{app[:attributes][:document_root]}" do
  source "drupal.erb"
  owner "root"
  group "root"
  mode 0644
  variables( :app => app )
end
