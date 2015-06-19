class BlockAssociateLine < ActiveRecord::Base
  belongs_to :block
  belongs_to :associate_line
end
