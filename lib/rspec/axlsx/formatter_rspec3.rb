require "rspec/core"
require "rspec/core/formatters/base_formatter"
require "rspec/axlsx/formatter/core"

module Rspec
  module Axlsx
    #class Formatter < ::RSpec::Core::Formatters::BaseFormatter
    class FormatterRSpec3 < ::RSpec::Core::Formatters::BaseFormatter
      ::RSpec::Core::Formatters.register self,
        :example_group_started, :stop,
        :example_passed, :example_failed

      def initialize(*)
        @example_groups = []
        @core = Rspec::Axlsx::Formatter::Core.new
      end

      def example_group_started(notification)
        @example_groups.push(notification.group)
      end

      def example_passed(notification)
        @example_groups.push(notification.example)
      end

      def example_failed(notification)
        @example_groups.push(notification.example)
      end

      def stop(notification)
        @core.to_sheet(@example_groups)
      end

    end
  end
end
