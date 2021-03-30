class VirtualCardTax < BaseCardTax
  def initialize
    super
    @withdraw = PercentageTax.new(BaseTax::TAXES[:virtual][:withdraw])
    @put = FixedTax.new(BaseTax::TAXES[:virtual][:put])
    @sender = FixedTax.new(BaseTax::TAXES[:virtual][:sender])
  end
end
