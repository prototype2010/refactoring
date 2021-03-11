module TerminalMenu
  def initial_menu
    {
      create: { description: nil, command: -> { create } },
      load: { description: nil, command: -> { load } }
    }
  end

  def main_menu
    loop do
      puts "\nWelcome, #{@account_manager.name}"
      puts 'If you want to:'

      print_shortcut_info(card_shortcuts)
      shortcut = input.to_sym

      return card_shortcuts.dig(shortcut, :command).call if card_shortcuts.key?(shortcut)

      puts "Wrong command. Try again!\n"
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

  def destroy_card
    loop do
      raise NoActiveCardsError unless @account_manager.has_cards?

      puts 'If you want to delete:'
      @account_manager.print_card_variant
      puts "press `exit` to exit\n"
      answer = gets.chomp
      break if answer == Constants::EXIT

      puts "Are you sure you want to delete #{@account_manager.card_by_index(answer.to_i).number}?[y/n]"

      return unless gets.chomp == Constants::YES

      @account_manager.destroy_card(answer.to_i)
      break

    rescue WrongCardNumber, NoActiveCardsError => e
      puts e.message
    end
  end

  def create_card
    loop do
      puts 'You could create one of 3 card types'
      puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - press `usual`'
      puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - press `capitalist`'
      puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - press `virtual`'
      puts '- For exit - press `exit`'
      @account_manager.create_card(gets.chomp)

      break

    rescue WrongCardTypeError => e
      puts e.message
      retry
    end
  end

  def destroy_account
    puts 'Are you sure you want to destroy account?[y/n]'
    return unless gets.chomp == Constants::YES

    @account_manager.self_destruct
    exit
  end

  def print_shortcut_info(shortcuts)
    shortcuts.each_pair { |shortcut, config| puts "- #{config.fetch(:description)} - press #{shortcut}" }
  end
end
