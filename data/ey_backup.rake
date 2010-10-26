require File.join(File.dirname(__FILE__), '/../../config/environment')
require 'rubygems'
require 'yaml'
require 'aws/s3'
require 'fileutils'

class Backup
  def initialize(type)
    @cfg = YAML::load(File.open(File.join(RAILS_ROOT, 'config', 'ey_backup.yml')))
    puts @cfg.inspect
    @file_name = ""
    @backup_dir = @cfg['engine_yard']['backup_tmp_dir']
    @target_bucket = @cfg['amazon_s3']['bucket']
    @application = @cfg['engine_yard']['application_name']
    @keep=@cfg['amazon_s3']['keep_databases']
    @type=type
    puts "#{@backup_dir} #{@target_bucket} #{@application} #{@keep} #{@type}"
    self.run
  end
  
  def run
    if @type == 'database'
      @keep=@cfg['amazon_s3']['keep_databases']
      self.dump_db
    elsif @type == 'files'
      @keep=@cfg['amazon_s3']['keep_files']
      self.dump_files
    else
      puts "Typ muze byt pouze files/database"
    end

    self.s3_connect
    self.upload
    self.delete_local_backup
    self.remove_old_backups
    self.s3_disconnect
  end
  
  def s3_connect
    AWS::S3::Base.establish_connection!(
      :access_key_id     => @cfg['amazon_s3']['access_key_id'],
      :secret_access_key => @cfg['amazon_s3']['secret_access_key']
    )
  end
  
  def s3_disconnect
    AWS::S3::Base.disconnect!
  end
  
  def upload
    AWS::S3::S3Object.store(self.s3_path,
      open(backup_file_name), @target_bucket
    )
  end
  
  def delete_local_backup
    FileUtils.rm(backup_file_name)
  end
  
  def dump_db
    db = ActiveRecord::Base.configurations[RAILS_ENV]['database']
    username = ActiveRecord::Base.configurations[RAILS_ENV]['username']
    pass = ActiveRecord::Base.configurations[RAILS_ENV]['password']
    @file_name = @application + '-' + Date.today.to_s + '-' + Time.now.strftime("%H-%M-%S") + '.sql.gz'
    #puts "mysqldump -p" + pass + " -u " + username + " " + db + " | gzip > " + self.backup_file_name
    system("mysqldump -p" + pass + " -u " + username + " " + db + " | gzip > " + self.backup_file_name)
  end

  def dump_files
    @file_name = @application + '-' + Date.today.to_s + '-' + Time.now.strftime("%H-%M-%S") + '.tar.gz'
    #puts "mysqldump -p" + pass + " -u " + username + " " + db + " | gzip > " + self.backup_file_name
    system("tar cfz #{self.backup_file_name} #{self.ey_shared_path}")
  end

  def s3_file_name
    "#{@application}/#{@file_name}".gsub("_", "-")
  end

  def backup_file_name
    File.join(@backup_dir, @file_name)
  end

  def s3_path
    "#{@application}/#{@type}/#{@file_name}".gsub(/_/, "-")
  end

  def ey_shared_path
    public_files = @cfg['engine_yard']['public_files_dir']
    "/data/#{@application}/shared/#{public_files}"
  end

  def remove_old_backups
    # There's a few buckets; we want the ey_backup bucket
    #puts AWS::S3::Service.buckets.inspect
    db_backup_bucket = AWS::S3::Service.buckets.detect {|b| b.instance_variable_get(:@attributes)["name"].match(/#{@target_bucket}/)}
    # Of the objects in the bucket, select out the ones
    db_backup_objects = db_backup_bucket.objects.select {|o| o.path.match(@application.gsub(/_/, "-") + '/' + @type)}
    # Pick the most recent backup
    oldest_backup = db_backup_objects.sort_by{|o| Time.parse(o.about["last-modified"]).to_i}.first
    # Remove the host_env.db_env pair from the path
    @last_backup = oldest_backup.key
    #puts "souboru: #{db_backup_objects.size}"
    if db_backup_objects.size > @keep
      #puts "mazu #{@last_backup}"
      AWS::S3::S3Object.delete(@last_backup, @target_bucket)
    end
  end
end
#------------------------------------------------------------------------------#
desc "Backup project to S3"
namespace :ey_backup do
  
  desc "Backup project db to S3"
  task :db do
    Backup.new('database')
    puts "\n-- End of backup --"
  end

  desc "Backup project files to S3"
  task :files do
    Backup.new('files')
    puts "\n-- End of backup --"
  end
end