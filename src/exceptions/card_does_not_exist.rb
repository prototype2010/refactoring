class CardDoesNotExist < StandardError
  def initialize(msg = nil)
    super(msg)
  end
end
