module CardsFactory
  CARD_TYPES = {
    usual: {
      start_balance: 50
    },
    capitalist: {
      start_balance: 100

    },
    virtual: {
      start_balance: 150
    }
  }.freeze

  class << self
    def create_card(card_type)
      type_sym = card_type.to_sym
      card_info = CARD_TYPES[type_sym]

      case type_sym
      when :usual
        UsualCard.new(UsualCardTax.new, card_info[:start_balance])
      when :capitalist
        CapitalistCard.new(CapitalistCardTax.new, card_info[:start_balance])
      when :virtual
        VirtualCard.new(VirtualCardTax.new, card_info[:start_balance])
      else
        raise WrongCardTypeError
      end
    end
  end
end
