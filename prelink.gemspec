# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{prelink}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Baobab Health"]
  s.date = %q{2012-09-19}
  s.description = %q{Interact with PreLink Lab Information Systems}
  s.email = %q{developers@baobabhealth.org}
  s.extra_rdoc_files = ["README.rdoc", "lib/prelink.rb"]
  s.files = ["README.rdoc", "Rakefile",
             "lib/prelink.rb",
             "spec/prelink_spec.rb", "spec/spec_helper.rb",
             "prelink.gemspec"]
  s.homepage = %q{http://github.com/baobabhealthtrust/prelink}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Prelink",
                    "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{PreLink Web Service client}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
