Gem::Specification.new do |s|
  s.name        = "curl-ffi"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Arthur Schreiber"]
  s.email       = ["schreiber.arthur@gmail.com"]
  s.homepage    = "http://github.com/nokarma/curl-ffi"
  s.summary     = "An FFI based libCurl interface"
  s.description = "An FFI based libCurl interface, intended to serve as a common backend for existing interfaces to libcurl"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "curl-ffi"

  s.add_dependency "ffi"
  s.add_development_dependency "rspec"

  s.files        = File.readlines('Manifest.txt').map { |line| line.strip }
  s.require_path = 'lib'
end