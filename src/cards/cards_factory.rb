module CardsFactory
  class << self
    def create_card(card_type)
      case card_type
      when 'usual' then UsualCard.new(UsualCardTax.new)
      when 'capitalist' then CapitalistCard.new(CapitalistCardTax.new)
      when 'virtual' then VirtualCard.new(VirtualCardTax.new)
      else raise WrongCardTypeError
      end
    end
  end
end
