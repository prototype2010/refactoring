class CapitalistCardTax < BaseCardTax
  def initialize
    super
    @withdraw = PercentageTax.new(BaseTax::TAXES[:capitalist][:withdraw])
    @put = FixedTax.new(BaseTax::TAXES[:capitalist][:put])
    @sender = PercentageTax.new(BaseTax::TAXES[:capitalist][:sender])
  end
end
