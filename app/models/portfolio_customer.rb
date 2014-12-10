class PortfolioCustomer < ActiveRecord::Base
  belongs_to :portfolio
  belongs_to :customer, polymorphic: true
end
