class UsualCardTax < BaseCardTax
  def initialize
    super
    @withdraw = PercentageTax.new(BaseTax::TAXES[:usual][:withdraw])
    @put = PercentageTax.new(BaseTax::TAXES[:usual][:put])
    @sender = FixedTax.new(BaseTax::TAXES[:usual][:sender])
  end
end
