class TaxIsHigherThanAmountError < StandardError
  def message
    'Your tax is higher than input amount'
  end
end
