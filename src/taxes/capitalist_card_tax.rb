class CapitalistCardTax < BaseCardTax
  def initialize
    super()
    @withdraw = PercentageTax.new(0.04)
    @put = FixedTax.new(10)
    @sender = PercentageTax.new(0.1)
  end
end
