# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ajax_pagination"
  s.version = "0.6.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ronald Ping Man Chan"]
  s.date = "2013-02-13"
  s.description = "Loads page content into AJAX sections with AJAX links, handling the details for you, load content with javascript into designated page containers. Supports multiple and/or nested AJAX sections. Designed to be easy to use, customizable, supports browser history robustly, supports AJAX forms and has many more features. Degrades gracefully when javascript is disabled."
  s.email = ["ronalchn@gmail.com"]
  s.homepage = "https://github.com/ronalchn/ajax_pagination"
  s.require_paths = ["lib"]
  s.rubyforge_project = "ajax_pagination"
  s.rubygems_version = "1.8.25"
  s.summary = "Handles AJAX site navigation, loads content into ajax_section containers using AJAX links."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<will_paginate>, [">= 0"])
      s.add_development_dependency(%q<ffi>, ["~> 1.0.11"])
      s.add_development_dependency(%q<thor>, ["~> 0.14.4"])
      s.add_development_dependency(%q<capybara>, ["~> 1.1"])
      s.add_development_dependency(%q<rails>, ["~> 3.2"])
      s.add_runtime_dependency(%q<rails>, ["~> 3.0"])
      s.add_runtime_dependency(%q<jquery-rails>, [">= 1.0.17"])
      s.add_runtime_dependency(%q<jquery-historyjs>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<will_paginate>, [">= 0"])
      s.add_dependency(%q<ffi>, ["~> 1.0.11"])
      s.add_dependency(%q<thor>, ["~> 0.14.4"])
      s.add_dependency(%q<capybara>, ["~> 1.1"])
      s.add_dependency(%q<rails>, ["~> 3.2"])
      s.add_dependency(%q<rails>, ["~> 3.0"])
      s.add_dependency(%q<jquery-rails>, [">= 1.0.17"])
      s.add_dependency(%q<jquery-historyjs>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<will_paginate>, [">= 0"])
    s.add_dependency(%q<ffi>, ["~> 1.0.11"])
    s.add_dependency(%q<thor>, ["~> 0.14.4"])
    s.add_dependency(%q<capybara>, ["~> 1.1"])
    s.add_dependency(%q<rails>, ["~> 3.2"])
    s.add_dependency(%q<rails>, ["~> 3.0"])
    s.add_dependency(%q<jquery-rails>, [">= 1.0.17"])
    s.add_dependency(%q<jquery-historyjs>, [">= 0"])
  end
end
