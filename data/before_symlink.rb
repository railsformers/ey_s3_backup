%w(photo_galleries  plugin_assets  user_files  user_images  videos images/captcha).each do |folder|
    run "echo 'release_path: #{release_path}/public/#{folder}' >> #{shared_path}/logs.log"
    run "ln -nfs #{shared_path}/public_files/#{folder} #{release_path}/public/#{folder}"
end