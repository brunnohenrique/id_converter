class ChipExchange < ActiveRecord::Base
  belongs_to :associate
  belongs_to :user
  belongs_to :chip_maintenance_type
  belongs_to :operator
end
