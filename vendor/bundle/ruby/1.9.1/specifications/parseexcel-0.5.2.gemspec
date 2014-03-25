# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "parseexcel"
  s.version = "0.5.2"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Hannes Wyss"]
  s.cert_chain = nil
  s.date = "2007-07-18"
  s.description = "Reads Excel documents on any platform"
  s.email = "hannes.wyss@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "usage-en.txt"]
  s.files = ["README", "COPYING", "usage-en.txt"]
  s.homepage = "http://rubyspreadsheet.sf.net"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubygems_version = "1.8.25"
  s.summary = "Reads Excel documents on any platform"

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
