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

  EXIT = 'exit'.freeze
  YES = 'y'.freeze
  NO = 'n'.freeze

  EXIT_PROMPT = "press `exit` to exit\n".freeze
end
