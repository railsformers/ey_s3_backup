require 'fileutils'

def src(*p)
  f << FileUtils.cp("#{File.dirname(__FILE__)}/../../data/")
  f = f + p
  return File.join(f)
end

desc "ey -> s3 backups"
namespace :ey_s3_backup do

  desc "Install ey_s3_backup files"
  task :install => :environment do
    puts "Installing files..."
    puts "Creating /deploy"
    FileUtils.mkdir(Dir.getwd + "/deploy")

    FileUtils.cp(src("before_restart.rb"), "./deploy")
    #FileUtils.cp(src("before_symlink.rb"), "./deploy")
    FileUtils.cp(src("ey_backup.yml"), "./config")
    FileUtils.cp(src("schedule.rb"), "./config")
    puts "Done."
    puts "!!!!! Edit config/ey_backup.yml !!!!!"
  end
end