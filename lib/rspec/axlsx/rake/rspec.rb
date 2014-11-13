namespace :axlsx do
  namespace :setup do
    task :spec_report_cleanup do
      rm_rf ENV["XLSX_REPORT"] || "spec/xlsx"
    end

    task :rspec => :spec_report_cleanup do
      setup_spec_opts
    end

    def setup_spec_opts(*extra_options)
      base_opts = [
        "--require", "#{File.dirname(__FILE__)}/rspec_loader.rb",
        "--format", "Rspec::AxlsxFormatter"
      ]

      spec_opts = (base_opts + extra_options).join(" ")
      ENV["SPEC_OPTS"] = "#{ENV['SPEC_OPTS']} #{spec_opts}"
    end
  end
end
