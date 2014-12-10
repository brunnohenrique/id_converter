class MasterOperatorContract < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :operator
end
