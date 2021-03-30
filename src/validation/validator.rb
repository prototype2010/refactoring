module Validator
  def validate_amount(amount)
    raise NumberExpectedError unless amount.is_a? Numeric
    raise InputCorrectAmount if amount <= 0
  end

  def validate_send(card, amount)
    raise CardInstanceExpectedError unless card.class.ancestors.include?(BaseCard)
    raise NotEnoughMoney unless card.send_possible?(amount)
    raise NotEnoughMoney unless card.put_possible?(amount)
  end
end
