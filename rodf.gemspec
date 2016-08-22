# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rodf/version'

Gem::Specification.new do |s|
  s.name = "rodf"
  s.version = RODF::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to?(:required_rubygems_version=)
  s.authors = ["Weston Ganger, Thiago Arrais, Foivos Zakkak"]
  s.description = "ODF generation library for Ruby"
  s.email = "thiago.arrais@gmail.com"
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE.LGPL", "README.md", "lib/rodf/cell.rb", "lib/rodf/column.rb", "lib/rodf/compatibility.rb", "lib/rodf/container.rb", "lib/rodf/data_style.rb", "lib/rodf/document.rb", "lib/rodf/hyperlink.rb", "lib/rodf/master_page.rb", "lib/rodf/page_layout.rb", "lib/rodf/paragraph.rb", "lib/rodf/paragraph_container.rb", "lib/rodf/property.rb", "lib/rodf/row.rb", "lib/rodf/skeleton.rb", "lib/rodf/skeleton/manifest.xml.erb", "lib/rodf/skeleton/styles.pxml", "lib/rodf/span.rb", "lib/rodf/spreadsheet.rb", "lib/rodf/style.rb", "lib/rodf/style_section.rb", "lib/rodf/tab.rb", "lib/rodf/table.rb", "lib/rodf/text.rb"]
  s.files = ["CHANGELOG", "Gemfile", "LICENSE.LGPL", "Manifest", "README.md", "Rakefile", "lib/rodf/cell.rb", "lib/rodf/column.rb", "lib/rodf/compatibility.rb", "lib/rodf/container.rb", "lib/rodf/data_style.rb", "lib/rodf/document.rb", "lib/rodf/hyperlink.rb", "lib/rodf/master_page.rb", "lib/rodf/page_layout.rb", "lib/rodf/paragraph.rb", "lib/rodf/paragraph_container.rb", "lib/rodf/property.rb", "lib/rodf/row.rb", "lib/rodf/skeleton.rb", "lib/rodf/skeleton/manifest.xml.erb", "lib/rodf/skeleton/styles.pxml", "lib/rodf/span.rb", "lib/rodf/spreadsheet.rb", "lib/rodf/style.rb", "lib/rodf/style_section.rb", "lib/rodf/tab.rb", "lib/rodf/table.rb", "lib/rodf/text.rb", "rodf.gemspec", "spec/cell_spec.rb", "spec/data_style_spec.rb", "spec/file_storage_spec.rb", "spec/hyperlink_spec.rb", "spec/master_page_spec.rb", "spec/page_layout_spec.rb", "spec/paragraph_spec.rb", "spec/property_spec.rb", "spec/row_spec.rb", "spec/skeleton_spec.rb", "spec/span_spec.rb", "spec/spec_helper.rb", "spec/spreadsheet_spec.rb", "spec/style_section_spec.rb", "spec/style_spec.rb", "spec/tab_spec.rb", "spec/table_spec.rb", "spec/text_spec.rb"]
  s.homepage = "http://github.com/thiagoarrais/rodf"
  s.rdoc_options = ["--line-numbers", "--title", "Rodf", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "rodf"
  s.rubygems_version = "1.8.25"
  s.summary = "ODF generation library for Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 3.0"])
      s.add_runtime_dependency(%q<rubyzip>, [">= 1.0"])
      s.add_runtime_dependency(%q<activesupport>, ["< 6.0", ">= 3.0"])
      s.add_development_dependency(%q<rspec>, [">= 2.9"])
      s.add_development_dependency(%q<rspec_hpricot_matchers>, [">= 1.0"])
      s.add_development_dependency(%q<echoe>, [">= 4.6"])
    else
      s.add_dependency(%q<builder>, [">= 3.0"])
      s.add_dependency(%q<rubyzip>, [">= 1.0"])
      s.add_dependency(%q<activesupport>, ["< 6.0", ">= 3.0"])
      s.add_dependency(%q<rspec>, [">= 2.9"])
      s.add_dependency(%q<rspec_hpricot_matchers>, [">= 1.0"])
      s.add_dependency(%q<echoe>, [">= 4.6"])
    end
  else
    s.add_dependency(%q<builder>, [">= 3.0"])
    s.add_dependency(%q<rubyzip>, [">= 1.0"])
    s.add_dependency(%q<activesupport>, ["< 6.0", ">= 3.0"])
    s.add_dependency(%q<rspec>, [">= 2.9"])
    s.add_dependency(%q<rspec_hpricot_matchers>, [">= 1.0"])
    s.add_dependency(%q<echoe>, [">= 4.6"])
  end
end
