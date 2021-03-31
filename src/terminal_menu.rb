module TerminalMenu
  # rubocop:disable Layout/LineLength
  CARD_CREATE_MESSAGE = 'You could create one of 3 card types \
      - Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - press `usual` \
      - Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - press `capitalist` \
      - Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - press `virtual` \
      - For exit - press `exit`'.freeze
  # rubocop:enable Layout/LineLength
  DESTROY_ACCOUNT_REQUEST = 'Are you sure you want to destroy account?[y/n]'.freeze
  WRONG_COMMAND = 'Wrong command. Try again!'.freeze

  def initial_menu
    {
      create: { description: nil, command: -> { create } },
      load: { description: nil, command: -> { load } }
    }
  end

  def main_menu
    loop do
      puts "Welcome, #{@account_manager.name} \
      If you want to:"

      print_shortcut_info(card_shortcuts)
      shortcut = input.to_sym

      return card_shortcuts.dig(shortcut, :command).call if card_shortcuts.key?(shortcut)

      puts WRONG_COMMAND
    end
  end

  def card_shortcuts
    {
      SC: { description: 'show all cards', command: -> { @account_manager.print_card_variant } },
      CC: { description: 'create card', command: -> { create_card } },
      DC: { description: 'destroy card', command: -> { destroy_card } },
      PM: { description: 'put money on card', command: -> { put_money } },
      WM: { description: 'withdraw money on card', command: -> { withdraw_money } },
      SM: { description: 'send money to another card', command: -> { send_money } },
      DA: { description: 'destroy account', command: -> { destroy_account } },
      exit: { description: 'exit from account', command: -> { exit } }
    }
  end

  def card_to_destroy
    @account_manager.print_card_variant
    puts Constants::EXIT_PROMPT
    gets.chomp
  end

  def destroy_card
    raise NoActiveCardsError unless @account_manager.cards?

    loop do
      card = card_to_destroy
      break if card == Constants::EXIT

      puts "Are you sure you want to delete #{@account_manager.card_by_index(card.to_i).number}?[y/n]"
      return unless gets.chomp == Constants::YES

      @account_manager.destroy_card(card.to_i)
      break
    rescue WrongCardNumber, NoActiveCardsError => e
      puts e.message
    end
  end

  def create_card
    loop do
      puts CARD_CREATE_MESSAGE
      @account_manager.create_card(gets.chomp)
      break
    rescue WrongCardTypeError => e
      puts e.message
      retry
    end
  end

  def destroy_account
    puts DESTROY_ACCOUNT_REQUEST
    return unless gets.chomp == Constants::YES

    @account_manager.self_destruct
    exit
  end

  def print_shortcut_info(shortcuts)
    shortcuts.each_pair { |shortcut, config| puts "- #{config.fetch(:description)} - press #{shortcut}" }
  end
end
