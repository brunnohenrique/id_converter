class ReservedProduct < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :reserve, polymorphic: true
  belongs_to :operator
end
