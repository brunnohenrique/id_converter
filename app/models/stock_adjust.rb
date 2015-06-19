class StockAdjust < ActiveRecord::Base
  belongs_to :stock_operation
  belongs_to :distributor
  belongs_to :user
  belongs_to :confirmator_user, class_name: 'User'
  belongs_to :operator
end
