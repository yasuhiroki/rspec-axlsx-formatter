require "axlsx"
require "axlsx/package"

module Rspec
  module Axlsx
    module Formatter
      class Core

        ALL_IN_ONE_SHEET = 0

        def initialize()
          @p = ::Axlsx::Package.new
          @workbook = @p.workbook

          @example_num = 0

          #@describe_column = ["Expected"]
          @describe_column = []

          @sheet_mode = ALL_IN_ONE_SHEET
        end

        def to_sheet(example_groups)
          @example_groups = example_groups
          convert_to_sheet do |worksheet|
          end
          @p.use_shared_strings = true
          FileUtils.mkdir_p("spec/xlsx")
          @p.serialize("spec/xlsx/report.xlsx")
        end

        private

        def success?(example)
          result = example.execution_result
          return result[:status] == "passed" if result.kind_of?(Hash) # RSpec2
          return result.status == :passed
        end

        def has_status?(example)
          example.respond_to?(:execution_result)
        end

        def sheet_style(worksheet)
          worksheet.column_widths(*[nil].concat(max_example_depth.times.map{5}))
          #worksheet.column_widths(nil, 5, 5)
        end

        def sheet_header(worksheet)
          worksheet.add_row do |row|
            row.add_cell('No'        , style: header_style)
            row.add_cell('Test Case' , style: header_style)
            max_example_depth.times{row.add_cell('', style: header_style)}
            @describe_column.each do |c|
              row.add_cell(c, style: header_style)
            end
            row.add_cell('Result'    , style: header_style)
          end
        end

        def convert_to_sheet
          if @sheet_mode == ALL_IN_ONE_SHEET
            @workbook.add_worksheet do |worksheet|
              sheet_header(worksheet)
              @example_groups.each do |example_group|
                add_sheet_row(worksheet, example_group)
              end
              sheet_style(worksheet)
            end
          else
            transepose = 
              @example_groups.inject({}) do |h, example_group|
              h[example_group.example.file_path] ||= []
              h[example_group.example.file_path].push(example_group)
              h
              end
            transepose.each do |k, v|
              @workbook.add_worksheet do |worksheet|
                yield(worksheet)
              end
            end
          end
        end

        def add_sheet_row(worksheet, example_group)
          worksheet.add_row do |row|
            if has_status?(example_group)
              @example_num += 1
              row.add_cell(@example_num, style: idx_column_style)
              example_depth(example_group).times do
                row.add_cell("", style: grey_style)
              end
              row.add_cell(example_group.description)
              offset = max_example_depth - example_depth(example_group) + @describe_column.length
              offset.times do
                row.add_cell("")
              end
              if success?(example_group)
                row.add_cell("T", style: success_style)
              else
                row.add_cell("F", style: failed_style)
              end
            else
              row.add_cell("", style: pink_style)
              example_depth(example_group).times do
                row.add_cell("", style: grey_style)
              end
              row.add_cell(example_group.description)
            end
          end
        end

        def max_example_depth
          @max_example_depth ||=
            @example_groups.map{|e| example_depth(e)}.max
        end

        def example_depth(example)
          if has_status?(example)
            example.example_group.parent_groups.select{|p| p != example}.length
          else
            example.parent_groups.select{|p| p != example}.length
          end
        end

        def style_hash
          {
            header_style: {
              bg_color: 'F4FA58',
              b: true,
              border: { style: :thin, color: '666666' },
            },
            idx_column_style: {
              bg_color: 'FFDD99',
              b: true,
              border: { style: :thin, color: '666666', edges: [:right] },
            },
            test_case_style: {
            },
            success_style: {
              bg_color: '58FA58',
            },
            failed_style: {
              bg_color: 'FE2E2E',
            },
            grey_space_style: {
              bg_color: 'CCCCCC',
            },
            pink_space_style: {
              bg_color: '6CEEC',
            },
          }
        end

        def header_style
          @header_style ||= @workbook.styles.add_style(style_hash[:header_style])
        end
        def pink_style
          @pink_style ||= @workbook.styles.add_style(style_hash[:idx_column_style].merge(style_hash[:pink_space_style]))
        end
        def grey_style
          @grey_style ||= @workbook.styles.add_style(style_hash[:grey_space_style])
        end
        def success_style
          @success_style ||= @workbook.styles.add_style(style_hash[:success_style])
        end
        def failed_style
          @failed_style ||= @workbook.styles.add_style(style_hash[:failed_style])
        end
        def idx_column_style
          @idx_column_style ||= @workbook.styles.add_style(style_hash[:idx_column_style])
        end
      end
    end
  end
end

