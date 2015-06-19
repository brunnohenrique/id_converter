class OperatorAccount < ActiveRecord::Base
  belongs_to :master, class_name: 'Distributor'
  belongs_to :operator
end
