class CardDoesNotExist < StandardError
  def message
    'Card does not exist'
  end
end
