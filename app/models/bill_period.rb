class BillPeriod < ActiveRecord::Base
  belongs_to :master_operator_contract
  belongs_to :export_bill
end
