class InternalPortabilityItem < ActiveRecord::Base
  belongs_to :internal_portability
  belongs_to :associate_line
  belongs_to :product_model
end
