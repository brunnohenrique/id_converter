class ProcessStep < ActiveRecord::Base
  belongs_to :process_type
  belongs_to :distributor
  belongs_to :operator
end
