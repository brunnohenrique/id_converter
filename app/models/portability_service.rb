class PortabilityService < ActiveRecord::Base
  belongs_to :internal_portability_item
  belongs_to :service
end
