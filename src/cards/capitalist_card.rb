class CapitalistCard < BaseCard
  def initialize(tax)
    super(tax)
    @type = 'capitalist'
    @balance = 100.00
  end
end
