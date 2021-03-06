require 'stackprof' rescue fail("install stackprof extension/gem")
require File.dirname(__FILE__) + '/theme_runner'

Liquid::Template.error_mode = ARGV.first.to_sym if ARGV.first
profiler = ThemeRunner.new
profiler.run

[:cpu, :object].each do |profile_type|
  puts "Profiling in #{profile_type.to_s} mode..."
  results = StackProf.run(mode: profile_type) do
    100.times do
      profiler.run
    end
  end
  StackProf::Report.new(results).print_text(false, 20)
  File.write(ENV['FILENAME'] + "." + profile_type.to_s, Marshal.dump(results)) if ENV['FILENAME']
end
