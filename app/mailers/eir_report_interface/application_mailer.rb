# frozen_string_literal: true

module EIRReportInterface
  # ApplicationMailer serves as the base class for all mailers in the EIRReportInterface module.
  # It provides default settings and layout configurations for the mailers.
  class ApplicationMailer < ActionMailer::Base
    default from: 'from@example.com'
    layout 'mailer'
  end
end
