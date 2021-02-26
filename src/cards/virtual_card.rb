class VirtualCard < BaseCard
  def initialize(tax)
    super(tax)
    @type = 'virtual'
    @balance = 150.00
  end
end
