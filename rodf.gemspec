# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rodf}
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Thiago Arrais"]
  s.date = %q{2010-04-19}
  s.description = %q{ODF generation library for Ruby}
  s.email = %q{thiago.arrais@gmail.com}
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE.LGPL", "README.rdoc", "lib/odf/cell.rb", "lib/odf/column.rb", "lib/odf/container.rb", "lib/odf/data_style.rb", "lib/odf/property.rb", "lib/odf/row.rb", "lib/odf/skeleton/manifest.xml", "lib/odf/skeleton/styles.xml", "lib/odf/spreadsheet.rb", "lib/odf/style_section.rb", "lib/odf/style.rb", "lib/odf/table.rb"]
  s.files = ["CHANGELOG", "LICENSE.LGPL", "Manifest", "README.rdoc", "Rakefile", "lib/odf/cell.rb", "lib/odf/column.rb", "lib/odf/container.rb", "lib/odf/data_style.rb", "lib/odf/property.rb", "lib/odf/row.rb", "lib/odf/skeleton/manifest.xml", "lib/odf/skeleton/styles.xml", "lib/odf/spreadsheet.rb", "lib/odf/style_section.rb", "lib/odf/style.rb", "lib/odf/table.rb", "rodf.gemspec", "spec/cell_spec.rb", "spec/data_style_spec.rb", "spec/property_spec.rb", "spec/row_spec.rb", "spec/spec_helper.rb", "spec/spreadsheet_spec.rb", "spec/style_section_spec.rb", "spec/style_spec.rb", "spec/table_spec.rb"]
  s.homepage = %q{http://github.com/thiagoarrais/rodf/tree}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rodf", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rodf}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{ODF generation library for Ruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<rubyzip>, [">= 0.9.1"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.1.2"])
      s.add_development_dependency(%q<rspec>, [">= 1.1.11"])
      s.add_development_dependency(%q<rspec_hpricot_matchers>, [">= 1.0"])
      s.add_development_dependency(%q<echoe>, [">= 3.0.2"])
    else
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<rubyzip>, [">= 0.9.1"])
      s.add_dependency(%q<activesupport>, [">= 2.1.2"])
      s.add_dependency(%q<rspec>, [">= 1.1.11"])
      s.add_dependency(%q<rspec_hpricot_matchers>, [">= 1.0"])
      s.add_dependency(%q<echoe>, [">= 3.0.2"])
    end
  else
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<rubyzip>, [">= 0.9.1"])
    s.add_dependency(%q<activesupport>, [">= 2.1.2"])
    s.add_dependency(%q<rspec>, [">= 1.1.11"])
    s.add_dependency(%q<rspec_hpricot_matchers>, [">= 1.0"])
    s.add_dependency(%q<echoe>, [">= 3.0.2"])
  end
end
