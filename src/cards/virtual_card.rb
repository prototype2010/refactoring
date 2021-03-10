class VirtualCard < BaseCard
  def initialize(tax)
    super(tax)
    @type = Constants::CARD_TYPES[:VIRTUAL]
    @balance = 150.00
  end
end
