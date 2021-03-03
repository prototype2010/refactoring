module Transfers
  def withdraw_money
    @current_account.print_card_variant
    puts 'Choose the card for withdrawing:'
    puts "press `exit` to exit\n"

    loop do
      answer = gets.chomp
      break if answer == 'exit'

      current_card = @current_account.card_by_index(answer)

      puts 'Input the amount of money you want to withdraw'
      current_card.withdraw(gets.chomp.to_i)
      @current_account.update
    end
  rescue NotEnoughMoney,
         InputCorrectAmount,
         WrongCardNumber,
         NoActiveCardsError => e
    puts e.message
  end

  def put_money
    @current_account.print_card_variant

    puts 'Choose the card for putting:'

    puts "press `exit` to exit\n"
    loop do
      answer = gets.chomp
      break if answer == 'exit'

      current_card = @current_account.card_by_index(answer)

      loop do
        puts 'Input the amount of money you want to put on your card'

        current_card.put(gets.chomp.to_i)
        @current_account.update

        return
      end
    end
  rescue InputCorrectAmount,
         TaxIsHigherThanAmountError,
         NoActiveCardsError,
         WrongCardNumber => e
    puts e.message
  end

  def send_money
    puts 'Choose the card for sending:'

    @current_account.print_card_variant

    puts "press `exit` to exit\n"
    answer = gets.chomp
    return if answer == 'exit'

    sender_card = @current_account.card_by_index(answer)

    puts 'Enter the recipient card:'
    recipient_card = find_card_by_number(gets.chomp)

    puts 'Input the amount of money you want to send'

    sender_card.send(gets.chomp.to_i, recipient_card)
    update_account_info(@current_account)
  rescue CardDoesNotExist,
         TaxIsHigherThanAmountError,
         NoActiveCardsError,
         WrongCardNumber,
         InputCorrectAmount => e
    puts e.message
  end
end
