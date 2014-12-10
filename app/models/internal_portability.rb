class InternalPortability < ActiveRecord::Base
  belongs_to :associate
  belongs_to :operator
  belongs_to :commercial_table
  belongs_to :plan_line, polymorphic: true
end
