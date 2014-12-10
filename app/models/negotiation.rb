class Negotiation < ActiveRecord::Base
  belongs_to :associate
  belongs_to :user
  belongs_to :seller, class_name: 'User', foreign_key: :seller_id
  belongs_to :plan
  belongs_to :distributor
  belongs_to :commercial_table
  belongs_to :operator
end
