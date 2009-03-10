# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'active_files'

task :default => 'test:run'

PROJ.name = 'active_files'
PROJ.authors = 'Clinton R. Nixon'
PROJ.email = 'clinton.nixon@viget.com'
PROJ.url = 'http://github.com/crnixon/active_files'
PROJ.rubyforge.name = 'active_files'

PROJ.version = ActiveFiles.version

PROJ.gem_dependencies = []

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "active_files"
    s.summary = "A file store for arbitrary objects, all easy-peasy."
    s.email = "crnixon@gmail.com"
    s.homepage = "http://github.com/crnixon/active_files"
    s.description = "TODO"
    s.authors = ["Clinton R. Nixon"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
