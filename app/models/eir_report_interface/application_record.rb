# frozen_string_literal: true

module EIRReportInterface
  # ApplicationRecord serves as the abstract base class for all models in the EIRReportInterface module.
  # It inherits from ActiveRecord::Base, making it a part of the ActiveRecord ORM system.
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
