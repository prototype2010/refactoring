module Constants
  CARD_LENGTH = 16
  CARD_TYPES = {
    USUAL: {
      name: 'usual',
      start_balance: 50
    },
    CAPITALIST: {
      name: 'capitalist',
      start_balance: 100
    },
    VIRTUAL: {
      name: 'virtual',
      start_balance: 150

    }
  }.freeze

  EXIT = 'exit'.freeze
  YES = 'y'.freeze
  NO = 'n'.freeze

  EXIT_PROMPT = "press `exit` to exit\n".freeze

  ACCOUNT_VALIDATION_PHRASES = {
    name: {
      first_letter: 'Your name must not be empty and starts with first upcase letter'
    },
    login: {
      present: 'Login must present',
      longer: 'Login must be longer then 4 symbols',
      shorter: 'Login must be shorter then 20 symbols',
      exists: 'Such account is already exists'
    },
    password: {
      present: 'Password must present',
      longer: 'Password must be longer then 6 symbols',
      shorter: 'Password must be shorter then 30 symbols'
    },
    age: {
      length: 'Your Age must be greeter then 23 and lower then 90'
    }
  }.freeze

end
