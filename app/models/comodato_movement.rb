class ComodatoMovement < ActiveRecord::Base
  belongs_to :stock_operation
  belongs_to :distributor
  belongs_to :associate_line
  belongs_to :product_model
  belongs_to :user
  belongs_to :sell
  belongs_to :operator
end
