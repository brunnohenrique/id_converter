class SellInternetItem < ActiveRecord::Base
  belongs_to :sell
  belongs_to :internet_plan
  belongs_to :negotiation_product
  belongs_to :number
end
