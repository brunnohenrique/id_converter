class CheckLineConsumptionCall < ActiveRecord::Base
  belongs_to :check_line_consumption
  belongs_to :call
end
