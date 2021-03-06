class SaveAnswer
  attr_accessor :answer, :step
  def initialize(answer:)
    self.answer = answer
    self.step = answer.step
  end

  def call(answer_params: {}, checkbox_params: {}, date_params: {})
    result = Result.new(false, answer)

    case step.contentful_type
    when "checkboxes"
      answer.assign_attributes(checkbox_params)
    when "single_date"
      answer.assign_attributes(date_params)
    else
      answer.assign_attributes(answer_params)
    end

    if answer.valid?
      answer.save
      ToggleAdditionalSteps.new(step: answer.step).call
      result.success = true
    end

    result
  end
end
