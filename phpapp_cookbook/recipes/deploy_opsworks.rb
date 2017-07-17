app = search(:aws_opsworks_app).first
rds_db_instance = search(:aws_opsworks_rds_db_instance).first
rds_db_name = search(:aws_opsworks_app).first[:data_sources].first[:database_name]
app_path = "/var/app"

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  opsworks_deploy_dir do
    user "www-data"
    group "www-data"
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
end

template '/var/app/creds.json' do
  source 'creds.erb'
  mode '0777'
  variables(
    :username => rds_db_instance[:db_user],
    :password => rds_db_instance[:db_password],
    :database => rds_db_name,
    :host => rds_db_instance[:address]
  )
end
