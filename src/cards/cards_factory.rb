module CardsFactory
  class << self
    def create_card(card_type)
      case card_type
      when Constants::CARD_TYPES[:USUAL][:name] then UsualCard.new(UsualCardTax.new)
      when Constants::CARD_TYPES[:CAPITALIST][:name] then CapitalistCard.new(CapitalistCardTax.new)
      when Constants::CARD_TYPES[:VIRTUAL][:name] then VirtualCard.new(VirtualCardTax.new)
      else raise WrongCardTypeError
      end
    end
  end
end
