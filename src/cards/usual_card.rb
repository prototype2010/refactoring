class UsualCard < BaseCard
  def initialize(tax)
    super(tax)
    @type = Constants::CARD_TYPES[:USUAL][:name]
    @balance = Constants::CARD_TYPES[:USUAL][:start_balance]
  end
end
