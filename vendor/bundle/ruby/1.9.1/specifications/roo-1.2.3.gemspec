# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "roo"
  s.version = "1.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Thomas Preymesser"]
  s.date = "2009-01-04"
  s.description = "roo can access the contents of OpenOffice-, Excel- or Google-Spreadsheets"
  s.email = "thopre@gmail.com"
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "test/no_spreadsheet_file.txt", "website/index.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "test/no_spreadsheet_file.txt", "website/index.txt"]
  s.homepage = "http://roo.rubyforge.org"
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "roo"
  s.rubygems_version = "1.8.25"
  s.summary = "roo can access the contents of OpenOffice-, Excel- or Google-Spreadsheets"

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<parseexcel>, [">= 0.5.2"])
      s.add_runtime_dependency(%q<rubyzip>, [">= 0.9.1"])
      s.add_runtime_dependency(%q<hpricot>, [">= 0.5"])
      s.add_runtime_dependency(%q<GData>, [">= 0.0.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.2"])
    else
      s.add_dependency(%q<parseexcel>, [">= 0.5.2"])
      s.add_dependency(%q<rubyzip>, [">= 0.9.1"])
      s.add_dependency(%q<hpricot>, [">= 0.5"])
      s.add_dependency(%q<GData>, [">= 0.0.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.2"])
    end
  else
    s.add_dependency(%q<parseexcel>, [">= 0.5.2"])
    s.add_dependency(%q<rubyzip>, [">= 0.9.1"])
    s.add_dependency(%q<hpricot>, [">= 0.5"])
    s.add_dependency(%q<GData>, [">= 0.0.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.2"])
  end
end
