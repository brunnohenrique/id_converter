class StockMovement < ActiveRecord::Base
  belongs_to :origin, class_name: 'Distributor'
  belongs_to :destiny, class_name: 'Distributor'
  belongs_to :user
  belongs_to :stock_operation
  belongs_to :operator
end
