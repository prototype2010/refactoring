class WrongCardNumber < StandardError
  def message
    "You entered wrong number!\n"
  end
end
