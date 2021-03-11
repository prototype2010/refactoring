class Account
  attr_reader :name, :login, :password
  attr_accessor :cards

  def initialize(registration)
    @name = registration.name
    @age = registration.age
    @password = registration.password
    @login = registration.login
    @cards = []
  end
end
