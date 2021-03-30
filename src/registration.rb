class Registration
  include AccountsRegister

  attr_reader :errors, :login, :password, :name, :age

  RULES = {
    login: {
      min: 4,
      max: 20
    },
    password: {
      min: 6,
      max: 30
    },
    age: {
      min: 23,
      max: 90
    }
  }.freeze
  
  ACCOUNT_VALIDATION_PHRASES = {
    name: {
      first_letter: 'Your name must not be empty and starts with first upcase letter'
    },
    login: {
      present: 'Login must present',
      longer: "Login must be longer then #{RULES[:login][:min]} symbols",
      shorter: "Login must be shorter then #{RULES[:login][:max]} symbols",
      exists: 'Such account is already exists'
    },
    password: {
      present: 'Password must present',
      longer: "Password must be longer then #{RULES[:password][:min]} symbols",
      shorter: "Password must be shorter then #{RULES[:password][:max]} symbols"
    },
    age: {
      length: "Your Age must be greeter then #{RULES[:age][:min]} \
and lower then #{RULES[:age][:max]}"
    }
  }.freeze

  

  NAME_REQUEST = 'Enter your name'.freeze
  LOGIN_REQUEST = 'Enter your login'.freeze
  PASSWORD_REQUEST = 'Enter your password'.freeze
  AGE_REQUEST = 'Enter your age'.freeze

  def initialize
    @name = nil
    @age = nil
    @password = nil
    @login = nil
    @errors = []
  end

  def start
    name_input
    age_input
    login_input
    password_input

    self
  end

  def name_input
    puts NAME_REQUEST
    @name = gets.chomp
    error_message = ACCOUNT_VALIDATION_PHRASES[:name][:first_letter]
    @errors.push(error_message) if @name.empty? || @name.capitalize != @name
  end

  def login_input
    login_messages = ACCOUNT_VALIDATION_PHRASES[:login]

    puts LOGIN_REQUEST
    @login = gets.chomp
    @errors.push(login_messages[:present]) if @login.empty?
    @errors.push('Login must be longer then 4 symbols') if @login.length < RULES[:login][:min]
    @errors.push('Login must be shorter then 20 symbols') if @login.length > RULES[:login][:max]
    @errors.push(login_messages[:exists]) if login_exists?(@login)
  end

  def password_input
    puts PASSWORD_REQUEST
    @password = gets.chomp
    @errors.push('Password must present') if @password == ''
    @errors.push('Password must be longer then 6 symbols') if @password.length < RULES[:password][:min]
    @errors.push('Password must be shorter then 30 symbols') if @password.length > RULES[:password][:max]
  end

  def age_input
    age_messages =

    puts AGE_REQUEST
    @age = gets.chomp.to_i
    if @age <= RULES[:age][:min] || @age >= RULES[:age][:max]
      @errors.push('Your Age must be greeter then 23 and lower then 90')
    end
  end

  def print_errors
    @errors.each do |e|
      puts e
    end
  end
end
