class WrongCardFormat < StandardError
  def message
    'Please, input correct number of card'
  end
end
