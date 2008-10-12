require 'rake/gempackagetask'
require 'rake/testtask'

version = ENV["VERSION"] || File.read("VERSION").strip
date = Time.now.strftime("%Y%m%d")

spec = Gem::Specification.new do |s|
  s.name = 'asciify'
  s.version = version.gsub("date",date)
  s.summary = "Tool to strip non-ASCII characters from a string and replace them with "+
              "something else"

  s.files = Dir['lib/**/*']

  s.require_path = 'lib'

  s.has_rdoc = true

  s.author = "Levin Alexander"
  s.homepage = "http://levinalex.de/ruby/asciify"
  s.email = "levin@grundeis.net"
end

task :package => [:test]

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.package_dir = "../pkg"
end

Rake::TestTask.new
