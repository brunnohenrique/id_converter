class DistributorLineReportStorage < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :export_bill
end
