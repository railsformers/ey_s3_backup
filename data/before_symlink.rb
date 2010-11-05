require 'fileutils'
folders = %w(public/photo_galleries public/plugin_assets public/user_files public/user_images public/videos public/images/captcha tmp/sessions var/data)

folders.each do |folder|
  if File.directory?(shared_path + "/public_files/" + folder)
    puts "#{folder} exist..."
  else
    puts "Creating #{folder}"
    FileUtils.mkdir_p(shared_path + "/public_files/" + folder)
  end
  run "echo 'ln -nfs #{shared_path}/public_files/#{folder} #{release_path}/#{folder}' >> #{shared_path}/logs.log"
  run "ln -nfs #{shared_path}/public_files/#{folder} #{release_path}/#{folder} >> #{shared_path}/logs.log"
end
