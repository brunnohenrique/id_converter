class BillAddition < ActiveRecord::Base
  belongs_to :bill_addition_type
  belongs_to :bill_period
  belongs_to :destiny, polymorphic: true
  belongs_to :distributor
end
