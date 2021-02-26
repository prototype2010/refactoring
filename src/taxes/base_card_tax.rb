class BaseCardTax
  attr_reader :withdraw, :put, :sender

  def initialize
    @withdraw = nil
    @put = nil
    @sender = nil
  end
end
