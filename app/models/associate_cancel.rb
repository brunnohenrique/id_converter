class AssociateCancel < ActiveRecord::Base
  belongs_to :associate
  belongs_to :cancel_reason
  belongs_to :user
end
