module CardsFactory
  class << self
    def create_card(card_type)
      case card_type
      when Constants::CARD_TYPES[:USUAL] then UsualCard.new(UsualCardTax.new)
      when Constants::CARD_TYPES[:CAPITALIST] then CapitalistCard.new(CapitalistCardTax.new)
      when Constants::CARD_TYPES[:VIRTUAL] then VirtualCard.new(VirtualCardTax.new)
      else raise WrongCardTypeError
      end
    end
  end
end
