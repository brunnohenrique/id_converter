class OperationControlItem < ActiveRecord::Base
  belongs_to :operation_control
  belongs_to :source, polymorphic: true
  belongs_to :number, -> { where 'operation_control_items.source_type' => 'Number' },
    foreign_key: :source_id
end
