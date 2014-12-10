class StockProduct < ActiveRecord::Base
  belongs_to :product_model
  belongs_to :color
  belongs_to :distributor
  belongs_to :number
  belongs_to :product_level
  belongs_to :local, polymorphic: true
  belongs_to :operator
end
