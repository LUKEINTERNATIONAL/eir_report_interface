# frozen_string_literal: true

EIRReportInterface::Engine.routes.each do
  get '/get_months', to: 'eir_report_interface#months_generator'
end
