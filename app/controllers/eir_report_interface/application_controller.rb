# frozen_string_literal: true

# ApplicationController serves as the base controller for all controllers
module EIRReportInterface
  # within the EIRReportInterface module. It inherits from ActionController::Base
  # and includes common configurations and protections for the controllers.
  class ApplicationController < ActionController::Base
    # Protects the application from Cross-Site Request Forgery (CSRF) attacks.
    # Uses the :exception strategy to raise an exception when a CSRF attack is detected.
    protect_from_forgery with: :exception
  end
end
