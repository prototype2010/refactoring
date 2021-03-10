class UsualCard < BaseCard
  def initialize(tax)
    super(tax)
    @type = Constants::CARD_TYPES[:USUAL]
    @balance = 50.00
  end
end
