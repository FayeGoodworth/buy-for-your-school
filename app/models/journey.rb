class Journey < ApplicationRecord
  self.implicit_order_column = "created_at"
  has_many :steps
  has_many :visible_steps, -> { where(steps: {hidden: false}) }, class_name: "Step"

  validates :liquid_template, presence: true

  def all_steps_completed?
    visible_steps.all? { |step| step.answer.present? }
  end
end
