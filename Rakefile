require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('ey_s3_backup', '0.0.1') do |p|
  p.description    = "Backup to S3"
  p.url            = "http://www.railsformers.com"
  p.author         = "Tomas Cigan"
  p.email          = "tomas@cigan.cz"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir['gem_tasks/**/*.rake'].each { |rake| load rake }
