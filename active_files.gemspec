# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{active_files}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Clinton R. Nixon"]
  s.date = %q{2009-03-10}
  s.description = %q{TODO}
  s.email = %q{crnixon@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["Manifest.txt", "README.rdoc", "VERSION.yml", "History.txt", "lib/active_files.rb", "lib/lib_helper.rb", "lib/active_files", "lib/active_files/record.rb", "test/test_active_files.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/crnixon/active_files}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A file store for arbitrary objects, all easy-peasy.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
