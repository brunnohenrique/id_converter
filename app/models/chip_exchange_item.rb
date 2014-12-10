class ChipExchangeItem < ActiveRecord::Base
  belongs_to :chip_exchange
  belongs_to :number
  belongs_to :old_stock_product, class_name: 'StockProduct'
  belongs_to :new_stock_product, class_name: 'StockProduct'
end
