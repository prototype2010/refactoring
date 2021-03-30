module CardsFactory
  CARD_TYPES = {
    usual: {
      name: 'usual',
      start_balance: 50
    },
    capitalist: {
      name: 'capitalist',
      start_balance: 100

    },
    virtual: {
      name: 'virtual',
      start_balance: 150
    }
  }.freeze

  class << self
    def create_card(card_type)
      card_info = card_init_params(card_type)

      init_card(card_type, card_info)
    end

    def init_card(type, card_info)
      case type
      when CARD_TYPES[:usual][:name]
        UsualCard.new(UsualCardTax.new, card_info[:start_balance])
      when CARD_TYPES[:capitalist][:name]
        CapitalistCard.new(CapitalistCardTax.new, card_info[:start_balance])
      when CARD_TYPES[:virtual][:name]
        VirtualCard.new(VirtualCardTax.new, card_info[:start_balance])
      else
        raise WrongCardTypeError
      end
    end

    def card_init_params(card_type)
      CARD_TYPES[card_type.to_sym]
    end
  end
end
