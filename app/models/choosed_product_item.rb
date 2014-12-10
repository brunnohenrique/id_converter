class ChoosedProductItem < ActiveRecord::Base
  belongs_to :choosed_product
  belongs_to :number
  belongs_to :stock_product
end
