# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jquery-historyjs"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["William Weidendorf"]
  s.date = "2013-10-25"
  s.description = "This gem provides History.js and the related HTML4 dependencies for using History.js with jQuery in your Rails 3+ application."
  s.email = ["wweidendorf@gmail.com"]
  s.homepage = "http://github.com/wweidendorf/jquery-historyjs"
  s.require_paths = ["lib"]
  s.rubyforge_project = "jquery-historyjs"
  s.rubygems_version = "1.8.25"
  s.summary = "Use History.js with Rails 3 and jQuery"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.0"])
      s.add_runtime_dependency(%q<thor>, [">= 0.14"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
    else
      s.add_dependency(%q<railties>, [">= 3.0"])
      s.add_dependency(%q<thor>, [">= 0.14"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.0"])
    s.add_dependency(%q<thor>, [">= 0.14"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
  end
end
