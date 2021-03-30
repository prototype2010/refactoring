class VirtualCardTax < BaseCardTax
  def initialize
    super
    @withdraw = PercentageTax.new(0.88)
    @put = FixedTax.new(1)
    @sender = FixedTax.new(1)
  end
end
