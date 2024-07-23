# frozen_string_literal: true

module EIRReportInterface
  # Engine class for the EIRReportInterface gem.
  #
  # This class is used to integrate the EIRReportInterface functionality into a Rails application.
  # It isolates the namespace for the gem to avoid conflicts with other parts of the application.
  #
  # For more information about configuring and using this engine, see the README file.
  class Engine < ::Rails::Engine
    isolate_namespace EIRReportInterface
  end
end
