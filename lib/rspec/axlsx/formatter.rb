require "rspec/axlsx/formatter/version"
require "rspec/core"

module Rspec
  rspec_version = Gem::Version.new(::RSpec::Core::Version::STRING)
  rspec_3 = Gem::Version.new('3.0.0')
  RSPEC_3_AVAILABLE = rspec_version >= rspec_3

  if RSPEC_3_AVAILABLE
    require "rspec/axlsx/formatter_rspec3"
    AxlsxFormatter = Rspec::Axlsx::FormatterRSpec3
  else
    require "rspec/axlsx/formatter_rspec2"
    AxlsxFormatter = Rspec::Axlsx::FormatterRSpec2
  end
end
