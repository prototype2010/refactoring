class VirtualCardTax < BaseCardTax
  def initialize
    super
    @withdraw = PercentageTax.new(Constants::TAXES[:virtual][:withdraw])
    @put = FixedTax.new(Constants::TAXES[:virtual][:put])
    @sender = FixedTax.new(Constants::TAXES[:virtual][:sender])
  end
end
