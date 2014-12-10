class Associate < ActiveRecord::Base
  belongs_to :partner
  belongs_to :distributor
  belongs_to :portfolio
end
