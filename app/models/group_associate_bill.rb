class GroupAssociateBill < ActiveRecord::Base
  belongs_to :export_bill
  belongs_to :associate
end
