class BaseTax
  TAXES = {
    capitalist: {
      withdraw: 0.04,
      put: 10,
      sender: 0.1,
    },
    virtual: {
      withdraw: 0.88,
      put: 1,
      sender: 1,
    },
    usual: {
      withdraw: 0.05,
      put: 0.02,
      sender: 20,
    }
  }

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def calculate
    raise NotImplementedError
  end
end
