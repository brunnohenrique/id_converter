class OperationControl < ActiveRecord::Base
  belongs_to :user
  belongs_to :creator, polymorphic: true
end
