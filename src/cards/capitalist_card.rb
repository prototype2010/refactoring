class CapitalistCard < BaseCard
  def initialize(tax)
    super(tax)
    @type = 'capitalist'
    @balance = Constants::CARD_TYPES[:CAPITALIST][:start_balance]
  end
end
