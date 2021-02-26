class UsualCardTax < BaseCardTax
  def initialize
    super()
    @withdraw = PercentageTax.new(0.05)
    @put = PercentageTax.new(0.02)
    @sender = FixedTax.new(20)
  end
end
