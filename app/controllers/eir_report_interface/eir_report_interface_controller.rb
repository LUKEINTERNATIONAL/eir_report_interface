# frozen_string_literal: true

# EIRReportInterface is a module that provides reporting services
# related to the EIR (Electronic Immunization Registry).
module EIRReportInterface
  # EIRReportInterfaceController handles requests for generating weeks and months data.
  class EIRReportInterfaceController < ::ApplicationController
    # Generates weeks data and renders it as JSON.
    def weeks_generator
      render json: service.weeks_generator
    end

    # Generates months data and renders it as JSON.
    def months_generator
      render json: service.months_generator
    end

    # Provides access to the service object.
    def service
      EIRReportInterface::EIRReportInterfaceService
    end
  end
end
