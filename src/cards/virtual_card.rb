class VirtualCard < BaseCard
  def initialize(tax)
    super(tax)
    @type = Constants::CARD_TYPES[:VIRTUAL][:name]
    @balance = Constants::CARD_TYPES[:VIRTUAL][:start_balance]
  end
end
