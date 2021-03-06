# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sanguinews/version"

Gem::Specification.new do |s|
  s.name        = "sanguinews"
  s.version     = Sanguinews::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tadeus Dobrovolskij"]
  s.email       = ["root@tad-do.net"]
  s.homepage    = "http://www.tad-do.net"
  s.summary     = %q{Simple, commandline client for Usenet uploads}
  s.license       = 'GPLv2'
  s.description = %q{Sanguinews is a simple, commandline client for Usenet(nntp) uploads. Inspired by newsmangler. Supports multithreading and SSL.}
  s.required_ruby_version = ">= 2.0"

  s.add_runtime_dependency "speedometer", '~> 0.1', '>= 0.1.3'
  s.add_runtime_dependency "nzb", "~> 0.2", '>= 0.2.2'
  s.add_runtime_dependency "parseconfig", "~> 1.0"

  s.add_development_dependency "rake", "~> 10.3"
  s.add_development_dependency "rake-compiler", "~> 0.9"

  s.extensions << "ext/yencoded/extconf.rb"

  s.files          = Dir.glob("ext/**/*.{c,rb,h}") +
            Dir.glob("lib/**/*.rb") + Dir.glob("*.conf")
  s.executables	  = 'sanguinews'
end
