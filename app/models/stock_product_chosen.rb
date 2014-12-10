class StockProductChosen < ActiveRecord::Base
  belongs_to :process_manager
  belongs_to :reserved_product
end
