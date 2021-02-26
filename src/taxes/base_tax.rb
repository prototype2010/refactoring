class BaseTax
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def calculate
    raise NotImplementedError
  end
end
