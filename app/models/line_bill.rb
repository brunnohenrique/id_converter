class LineBill < ActiveRecord::Base
  belongs_to :bill_period
  belongs_to :associate_bill
  belongs_to :associate_line
  belongs_to :line_group
end
