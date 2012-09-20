require 'bundler'                                                               
Bundler::GemHelper.install_tasks                                                
                                                                                
# require 'spec/rake/spectask' 
require 'rspec/core/rake_task'

desc "Run all RSpec tests"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color --format documentation --backtrace]
  t.pattern = 'spec/*_spec.rb'
end
