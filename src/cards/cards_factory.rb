module CardsFactory
  CARD_TYPES = {
    USUAL: {
      name: 'usual',
      start_balance: 50
    },
    CAPITALIST: {
      name: 'capitalist',
      start_balance: 100

    },
    VIRTUAL: {
      name: 'virtual',
      start_balance: 150
    }
  }.freeze

  class << self
    def create_card(card_type)
      card_key = card_type.to_sym.upcase

      raise WrongCardTypeError unless CARD_TYPES.key?(card_key)

      card_info = CARD_TYPES.fetch(card_key)

      case card_type
      when CARD_TYPES[:USUAL][:name]
        UsualCard.new(UsualCardTax.new, card_info[:start_balance], card_key)
      when CARD_TYPES[:CAPITALIST][:name]
        CapitalistCard.new(CapitalistCardTax.new, card_info[:start_balance],
                           card_key)
      when CARD_TYPES[:VIRTUAL][:name]
        VirtualCard.new(VirtualCardTax.new, card_info[:start_balance], card_key)
      end
    end
  end
end
