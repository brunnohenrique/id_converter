class BillAdditionItem < ActiveRecord::Base
  belongs_to :bill_addition
  belongs_to :destiny_bill, polymorphic: true
end
