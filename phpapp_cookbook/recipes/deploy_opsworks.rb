command = search(:aws_opsworks_app)
app = search(:aws_opsworks_app, "app_id:#{command[:args][:app_ids].first}")
app_path = "/var/www/" + app[:shortname]

# deploy git repo from opsworks app
application app_path do
  owner 'www-data'
  group 'www-data'

  git app_path do
    user 'www-data'
    group 'www-data'
    repository app[:app_source][:url]
    deploy_key app[:app_source][:ssh_key]
  end
end

# Drupal 7 Nginx config file
if app[:environment][:APP_TYPE] == 'drupal7'
    template "/etc/nginx/sites-enabled/#{app[:shortname]}" do
      source "drupal7.erb"
      owner "root"
      group "root"
      mode 0644
      variables( :app => app )
    end
end

# Drupal 8 Nginx config file
if app[:environment][:APP_TYPE] == 'drupal8'
    template "/etc/nginx/sites-enabled/#{app[:shortname]}" do
      source "drupal8.erb"
      owner "root"
      group "root"
      mode 0644
      variables( :app => app )
    end
end

# Wordpress Nginx config file
if app[:environment][:APP_TYPE] == 'wordpress'
    template "/etc/nginx/sites-enabled/#{app[:shortname]}" do
      source "wordpress.erb"
      owner "root"
      group "root"
      mode 0644
      variables( :app => app )
    end
end

# restart nginx
service "nginx" do
  supports :status => true, :restart => true, :reload => true, :stop => true, :start => true
  action :reload
end
