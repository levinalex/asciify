spec = Gem::Specification.new do |s|
  s.name = 'asciify'
  s.version = "0.3.0"
  s.summary = "strip non-ASCII characters from a string and replace them with something else"
  s.files = Dir['lib/**/*']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.author = "Levin Alexander"
  s.homepage = "http://levinalex.net/src/asciify"
  s.email = "levin@grundeis.net"

  s.add_runtime_dependency 'iconv'
end