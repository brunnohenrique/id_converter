class Distributor < ActiveRecord::Base
  belongs_to :brand
  belongs_to :master, class_name: 'Distributor', foreign_key: :master_id
end
