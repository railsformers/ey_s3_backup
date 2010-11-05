require 'fileutils'

def src(*p)
  f = Array.new
  f << "#{File.dirname(__FILE__)}/../data/"
  f = f + p
  return File.join(f)
end

desc "ey -> s3 backups"
namespace :ey_s3_backup do

  desc "Install ey_s3_backup files"
  task :install => :environment do
    if File.exist?(Dir.getwd + "/Rakefile")
      puts "Installing files..."
      puts "Creating /deploy"
      if File.directory?(Dir.getwd + "/deploy")
        puts "/deploy exist..."
      else
        FileUtils.mkdir_p(Dir.getwd + "/deploy")
      end
      FileUtils.cp(src("before_restart.rb"), "./deploy")
      #FileUtils.cp(src("before_symlink.rb"), "./deploy")
      FileUtils.cp(src("ey_backup.yml"), "./config")
      FileUtils.cp(src("schedule.rb"), "./config")
      puts "Editing Rakefile"
      puts "Rakefile exist, adding Dir[\"\#{Gem.searcher.find('ey_s3_backup').full_gem_path}/gem_tasks/*.rake\"].each { |ext| load ext }"
      
      open('Rakefile', 'a') { |f|
        f.puts "\n Dir[\"\#{Gem.searcher.find('ey_s3_backup').full_gem_path}/gem_tasks/*.rake\"].each { |ext| load ext }"
      }
      puts "Done."
      puts "!!!!! Edit config/ey_backup.yml !!!!!"
    else
      puts "ERROR: Rakefile not found."
    end
  end
end