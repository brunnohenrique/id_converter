class PlanShift < ActiveRecord::Base
  belongs_to :associate
  belongs_to :plan, polymorphic: true
  belongs_to :distributor
  belongs_to :user
  belongs_to :facility_package
  belongs_to :operator
end
