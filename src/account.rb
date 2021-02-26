class Account
  include FileUtils

  attr_reader :name, :login, :cards, :password

  def initialize(registration)
    @name = registration.name
    @age = registration.age
    @password = registration.password
    @login = registration.login
    @cards = []
  end

  def update
    update_account_info(self)
  end

  def create_card(card_type)
    @cards = @cards.push(CardsFactory.create_card(card_type))

    update
  end

  def destroy_card(card_index)
    @cards = @cards
             .each_with_index
             .reject { |_cards, index| (index + 1) == card_index }

    update
  end

  def card_by_index(card_number)
    card_index = card_number.to_i - 1

    raise WrongCardNumber if @cards[card_index].nil?

    @cards[card_index]
  end

  def print_card_variant
    raise NoActiveCardsError unless cards.any?

    @cards.each_with_index do |c, i|
      puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
    end
  end

  def self_destruct
    delete_account(self)
  end
end
