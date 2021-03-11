module Validator
  def valid_amount?(amount)
    raise NumberExpectedError unless amount.is_a? Numeric
    raise InputCorrectAmount if amount <= 0
  end
end