class OperatorBill < ActiveRecord::Base
  belongs_to :master, class_name: 'Distributor'
  belongs_to :operator
  belongs_to :bill_period
  belongs_to :operator_account
end
