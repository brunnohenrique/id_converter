class Portfolio < ActiveRecord::Base
  belongs_to :owner, class_name: 'Distributor'
end
