@rails_env = node[:environment][:framework_env]
run "cd #{release_path} && whenever --update-crontab '#{shared_path.split("/")[2]}' --set environment=#{@rails_env}"
