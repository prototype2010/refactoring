class CapitalistCardTax < BaseCardTax
  def initialize
    super
    @withdraw = PercentageTax.new(Constants::TAXES[:capitalist][:withdraw])
    @put = FixedTax.new(Constants::TAXES[:capitalist][:put])
    @sender = PercentageTax.new(Constants::TAXES[:capitalist][:sender])
  end
end
