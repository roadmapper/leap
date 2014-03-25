# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "GData"
  s.version = "0.0.4"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Dion Almaer"]
  s.cert_chain = nil
  s.date = "2007-06-19"
  s.description = "== FEATURES/PROBLEMS:  To start out the API set isn't covered. The aim is to support the GData API itself, and then higher level classes for the various Google APIs.  Current support:  * Google Account Authentication: Handle Google ClientLogin API * Google Spreadsheet Data API  Future support:"
  s.email = "dion@almaer.com"
  s.executables = ["addenclosure", "bloggerfeed", "bloggerpost", "gspreadsheet", "removeenclosure"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["bin/addenclosure", "bin/bloggerfeed", "bin/bloggerpost", "bin/gspreadsheet", "bin/removeenclosure", "History.txt", "Manifest.txt", "README.txt"]
  s.homepage = "    by Dion Almaer"
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = "gdata-ruby"
  s.rubygems_version = "1.8.25"
  s.summary = "Google GData Ruby API"

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<hoe>, [">= 1.2.1"])
    else
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<hoe>, [">= 1.2.1"])
    end
  else
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<hoe>, [">= 1.2.1"])
  end
end
