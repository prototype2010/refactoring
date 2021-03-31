class NotEnoughMoney < StandardError
  def message
    "You don't have enough money on card for such operation"
  end
end
