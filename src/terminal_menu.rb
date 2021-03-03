module TerminalMenu
  def initial_menu
    {
      create: {
        description: nil,
        command: -> { create }
      },
      load: {
        description: nil,
        command: -> { load }
      }
    }
  end

  def main_menu
    loop do
      puts "\nWelcome, #{@current_account.name}"
      puts 'If you want to:'

      print_shortcut_info(card_shortcuts)

      shortcut = input.to_sym

      return card_shortcuts.dig(shortcut, :command).call if card_shortcuts.key?(shortcut)

      puts "Wrong command. Try again!\n"
    end
  end

  def card_shortcuts
    {
      SC: {
        description: 'show all cards',
        command: -> { @current_account.print_card_variant }
      },
      CC: {
        description: 'create card',
        command: -> { create_card }
      },
      DC: {
        description: 'destroy card',
        command: -> { destroy_card }
      },
      PM: {
        description: 'put money on card',
        command: -> { put_money }
      },
      WM: {
        description: 'withdraw money on card',
        command: -> { withdraw_money }
      },
      SM: {
        description: 'send money to another card',
        command: -> { send_money }
      },
      DA: {
        description: 'destroy account',
        command: lambda do
          destroy_account
          exit
        end
      },
      exit: {
        description: 'exit from account',
        command: lambda do
          exit
        end
      }
    }
  end

  def destroy_card
    loop do
      raise NoActiveCardsError if @current_account.cards.empty?

      puts 'If you want to delete:'
      @current_account.print_card_variant
      puts "press `exit` to exit\n"
      answer = gets.chomp
      break if answer == 'exit'

      puts "Are you sure you want to delete #{@current_account.card_by_index(answer.to_i).number}?[y/n]"

      return unless gets.chomp == 'y'

      @current_account.destroy_card(answer.to_i)
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
      @current_account.create_card(gets.chomp)

      break

    rescue WrongCardTypeError => e
      puts e.message
      retry
    end
  end

  def destroy_account
    puts 'Are you sure you want to destroy account?[y/n]'
    @current_account.self_destruct if gets.chomp == 'y'
  end

  def print_shortcut_info(shortcuts)
    shortcuts.each_pair { |shortcut, config| puts "- #{config.fetch(:description)} - press #{shortcut}" }
  end
end
