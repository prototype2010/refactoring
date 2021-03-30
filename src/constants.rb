module Constants
  ACCOUNT = {
    login: {
      min: 4,
      max: 20
    },
    password: {
      min:6,
      max:30
    },
    age: {
      min: 23,
      max: 90
    }
  }

  CARD_TYPES = {
    USUAL: {
      name: 'usual',
      start_balance: 50,
    },
    CAPITALIST: {
      name: 'capitalist',
      start_balance: 100,

    },
    VIRTUAL: {
      name: 'virtual',
      start_balance: 150,
    }
  }.freeze

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

  EXIT = 'exit'.freeze
  YES = 'y'.freeze
  NO = 'n'.freeze

  EXIT_PROMPT = "press `exit` to exit\n".freeze
end
