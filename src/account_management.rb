class AccountManagement
  include AccountsRegister

  def initialize(account)
    @account = account
  end

  def name
    @account.name
  end

  def update
    update_account_info(@account)
  end

  def has_cards?
    @account.cards.length.positive?
  end

  def create_card(card_type)
    @account.cards.push(CardsFactory.create_card(card_type))

    update
  end

  def destroy_card(card_index)
    @account.cards = @account.cards
                             .each_with_index
                             .reject { |_cards, index| (index + 1) == card_index }

    update
  end

  def card_by_index(card_number)
    card_index = card_number.to_i - 1

    raise WrongCardNumber if @account.cards[card_index].nil?

    @account.cards[card_index]
  end

  def cards
    @account.cards
  end

  def print_card_variant
    raise NoActiveCardsError unless @account.cards.any?

    @account.cards.each_with_index do |c, i|
      puts "- #{c.number}, #{c.type}, press #{i + 1}"
    end
  end

  def self_destruct
    delete_account(@account)
  end
end
