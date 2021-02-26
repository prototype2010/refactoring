class UsualCard < BaseCard
  def initialize(tax)
    super(tax)
    @type = 'usual'
    @balance = 50.00
  end
end
