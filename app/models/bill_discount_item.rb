class BillDiscountItem < ActiveRecord::Base
  belongs_to :bill_discount
  belongs_to :destiny_bill, polymorphic: true
end
