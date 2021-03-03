class Registration
  include FileUtils

  attr_reader :errors, :login, :password, :name, :age

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
    puts 'Enter your name'
    @name = gets.chomp
    error_message = 'Your name must not be empty and starts with first upcase letter'
    @errors.push(error_message) if @name.empty? || @name.capitalize != @name
  end

  def login_input
    puts 'Enter your login'
    @login = gets.chomp
    @errors.push('Login must present') if @login == ''
    @errors.push('Login must be longer then 4 symbols') if @login.length < 4
    @errors.push('Login must be shorter then 20 symbols') if @login.length > 20
    @errors.push('Such account is already exists') if login_exists?(@login)
  end

  def password_input
    puts 'Enter your password'
    @password = gets.chomp
    @errors.push('Password must present') if @password == ''
    @errors.push('Password must be longer then 6 symbols') if @password.length < 6
    @errors.push('Password must be shorter then 30 symbols') if @password.length > 30
  end

  def age_input
    puts 'Enter your age'
    @age = gets.chomp.to_i
    @errors.push('Your Age must be greeter then 23 and lower then 90') if @age <= 23 || @age >= 90
  end

  def print_errors
    @errors.each do |e|
      puts e
    end
  end
end
