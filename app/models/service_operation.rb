class ServiceOperation < ActiveRecord::Base
  belongs_to :user
  belongs_to :associate
  belongs_to :operator
end
