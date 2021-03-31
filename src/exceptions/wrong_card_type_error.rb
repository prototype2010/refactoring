class WrongCardTypeError < StandardError
  def message
    "Wrong card type. Try again!\n"
  end
end
