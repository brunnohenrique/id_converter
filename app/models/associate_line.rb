class AssociateLine < ActiveRecord::Base
  belongs_to :associate
  belongs_to :sell
  belongs_to :number
  belongs_to :plan_line, polymorphic: true
  belongs_to :plan, -> { where 'associate_lines.plan_line_type' => 'Plan' },
    foreign_key: 'plan_line_id'
  belongs_to :internet_plan, -> { where 'associate_lines.plan_line_type' => 'InternetPlan' },
    foreign_key: 'plan_line_id'
  belongs_to :line_group
end
