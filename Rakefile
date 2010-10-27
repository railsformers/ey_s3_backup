require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('ey_s3_backup', '0.0.4') do |p|
  p.description    = "Backup to S3"
  p.url            = "http://www.railsformers.com"
  p.author         = "Railsformers"
  p.email          = "info@railsformers.com"
  p.ignore_pattern = ["tmp/*", "script/*", "nbproject/*"]
  p.development_dependencies = ["rake", "whenever", "aws-s3"]
  p.runtime_dependencies = ["whenever", "aws-s3"]
end

Dir['gem_tasks/**/*.rake'].each { |rake| load rake }
