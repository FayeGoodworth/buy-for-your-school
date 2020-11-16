class AnswerFactory
  attr_accessor :question

  def initialize(question:)
    self.question = question
  end

  def call
    case question.contentful_type
    when "radios" then RadioAnswer.new
    when "short_text" then ShortTextAnswer.new
    when "long_text" then LongTextAnswer.new
    end
  end
end