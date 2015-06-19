class Block < ActiveRecord::Base
  belongs_to :associate, foreign_key: :destiny_id
end
