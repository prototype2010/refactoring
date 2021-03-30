class CapitalistCard < BaseCard
  def initialize(tax)
    super(tax)
    @type = Constants::CARD_TYPES[:CAPITALIST][:name]
    @balance = Constants::CARD_TYPES[:CAPITALIST][:start_balance]
  end
end
