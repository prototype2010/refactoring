class InputCorrectAmount < StandardError
  def message
    'You must input correct amount of money'
  end
end
