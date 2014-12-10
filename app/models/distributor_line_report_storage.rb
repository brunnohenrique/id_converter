class DistributorLineReportStorage < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :bill_period
end
