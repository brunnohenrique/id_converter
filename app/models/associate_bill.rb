class AssociateBill < ActiveRecord::Base
  belongs_to :bill_period
  belongs_to :associate
  belongs_to :group_associate_bill
end
