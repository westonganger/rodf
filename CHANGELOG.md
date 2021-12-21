# CHANGELOG

## Unreleased - [View Diff](https://github.com/westonganger/rodf/compare/v1.1.1..master)
- Allow passing `:style` argument to `Span`
- Added `Table#set_column_widths` method
- Style `:family` option now supports String and Symbol keys. Previously `:family` the family option would only support the key name as a Symbol.
- Improve Style List Documentation
- Allow adding XML attributes directly to `Table`, `Row`, `Column`, `Cell` using the `:attributes` argument
- Remove usage of `contains` metaprogramming method `Container#contains` that was hiding major implementation details from most RODF classes. The code is now much easier to understand.

## v1.1.1 - [View Diff](https://github.com/westonganger/rodf/compare/v1.1.0..v1.1.1)
- [Issue #36](https://github.com/westonganger/rodf/issues/36) - Improve compatibility for Float Cells
- Fix gemspec require for Ruby 1.9
- Cleanup File Commenting

## v1.1.0 - [View Diff](https://github.com/westonganger/rodf/compare/v1.0.0..v1.1.0)
- [#34](https://github.com/westonganger/rodf/pull/34) - Add ability to add many rows or cells at once
- [#29](https://github.com/westonganger/rodf/pull/29) - Remove ActiveSupport dependency in favor of `dry-inflector`
- [#21](https://github.com/thiagoarrais/rodf/pull/21) - Allow more attributes for the `data_style` method
- [#19](https://github.com/westonganger/rodf/issues/19) - Changes to Date/Time handling

## v1.0.0 - [View Diff](https://github.com/westonganger/rodf/compare/v0.3.7..v1.0.0)
- Rename main module ODF to RODF, Fix cell types

## v0.3.7
- Add Rails 5 support to gemspec

## v0.3.6
- Resulting ODF files as bitstrings

## v0.3.5
- Allows current libraries

## v0.3.4
- Procedural cell styling

## v0.3.3
- Documents can now write themselves to disk

## v0.3.2
- Fixes broken styles.xml

## v0.3.1
- Adds support for conditional formatting

## v0.3.0
- Allow parameterless blocks

## v0.2.2
- Reintroduce compatibility with Ruby 1.8

## v0.2.1
- Update to newer libraries and Ruby 1.9

## v0.1.6
- Fix date handling

## v0.1.5
- Bug fix

## v0.1.4
- Allow the setting of an entire cell's content to a hyperlink (by Merul Patel)

## v0.1.3
- Dependency fix (by Merul Patel)

## v0.1.2 
- Cell span

## v0.1.1
- Basic spreadsheet styling support

## v0.1.0
- First version with very basic support for spreadsheet generation
