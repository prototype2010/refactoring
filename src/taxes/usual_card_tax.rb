class UsualCardTax < BaseCardTax
  def initialize
    super
    @withdraw = PercentageTax.new(Constants::TAXES[:usual][:withdraw])
    @put = PercentageTax.new(Constants::TAXES[:usual][:put])
    @sender = FixedTax.new(Constants::TAXES[:usual][:sender])
  end
end
