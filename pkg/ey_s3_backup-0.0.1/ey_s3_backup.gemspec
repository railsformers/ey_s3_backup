# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ey_s3_backup}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tomas Cigan"]
  s.date = %q{2010-10-26}
  s.description = %q{Backup to S3}
  s.email = %q{tomas@cigan.cz}
  s.extra_rdoc_files = ["README.rdoc", "lib/ey_s3_backup.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "data/before_restart.rb", "data/before_symlink.rb", "data/ey_backup.rake", "data/ey_backup.yml", "data/schedule.rb", "gem_tasks/ey_backup.rake", "gem_tasks/install.rake", "init.rb", "lib/ey_s3_backup.rb", "ey_s3_backup.gemspec"]
  s.homepage = %q{www.railsformers.com}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ey_s3_backup", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ey_s3_backup}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Backup to S3}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
