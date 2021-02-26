class PercentageTax < BaseTax
  def calculate(amount)
    amount * @value
  end
end
