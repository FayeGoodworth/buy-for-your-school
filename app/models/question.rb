class Question < ApplicationRecord
  self.implicit_order_column = "created_at"
  belongs_to :plan

  has_one :radio_answer
  has_one :short_text_answer

  def radio_options
    options.map { |option| OpenStruct.new(id: option.downcase, name: option.titleize) }
  end

  def find_answer
    @answer ||= radio_answer || short_text_answer
  end
end
