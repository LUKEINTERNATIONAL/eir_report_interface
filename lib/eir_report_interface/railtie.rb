# frozen_string_literal: true

require 'rails/railtie'

module EIRReportInterface
  # Railtie class for the EIRReportInterface gem.
  #
  # This Railtie integrates the EIRReportInterface functionality into a Rails application.
  # It allows you to configure initialization options for the gem within a Rails context.
  #
  # For more information about configuring and using this Railtie, see the README file of the gem.
  class Railtie < Rails::Railtie
    initializer 'eir_report_interface.configure_rails_initialization' do
      # Custom initialization code
    end
  end
end
