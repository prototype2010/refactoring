class NoActiveCardsError < StandardError
  def message
    "There is no active cards!\n"
  end
end
