require "rspec/core/formatters/base_formatter"
require "rspec/axlsx/formatter/core"

module Rspec
  module Axlsx
    #class Formatter < ::RSpec::Core::Formatters::BaseFormatter
    class FormatterRSpec2 < ::RSpec::Core::Formatters::BaseFormatter

      def initialize(*)
        super
        @example_groups = []
        @core = Rspec::Axlsx::Formatter::Core.new
      end

      def example_group_started(example_group)
        @example_groups.push(example_group)
      end

      def example_passed(example)
        @example_groups.push(example)
      end

      def example_failed(example)
        @example_groups.push(example)
      end

      def dump_summary(*args)
        @core.to_sheet(@example_groups)
      end

    end
  end
end

