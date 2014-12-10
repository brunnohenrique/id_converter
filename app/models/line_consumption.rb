class LineConsumption < ActiveRecord::Base
  belongs_to :bill
  belongs_to :tariff
  belongs_to :associate_line_service
end
