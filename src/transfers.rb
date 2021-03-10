module Transfers
  def withdraw_money
    @current_account.print_card_variant
    puts 'Choose the card for withdrawing:'
    puts "press `exit` to exit\n"

    answer = gets.chomp
    return if answer == Constants::EXIT

    current_card = @current_account.card_by_index(answer)

    puts 'Input the amount of money you want to withdraw'
    current_card.withdraw(gets.chomp.to_i)
    @current_account.update
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
    answer = gets.chomp
    return if answer == Constants::EXIT

    current_card = @current_account.card_by_index(answer)

    puts 'Input the amount of money you want to put on your card'

    current_card.put(gets.chomp.to_i)
    @current_account.update
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
    return if answer == Constants::EXIT

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
