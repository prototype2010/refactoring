module Transfers
  WITHDRAW_REQUEST = 'Choose the card for withdrawing:'.freeze
  CHOOSE_CARD_REQUEST = 'Choose the card for putting:'.freeze
  WITHDRAW_AMOUNT_REQUEST = 'Input the amount of money you want to withdraw'.freeze
  PUT_AMOUNT_REQUEST = 'Input the amount of money you want to put on your card'.freeze
  SEND_CARD_REQUEST = 'Choose the card for sending:'.freeze
  SEND_AMOUNT_REQUEST = 'Input the amount of money you want to send'.freeze
  RECIPIENT_CARD_REQUEST = 'Enter the recipient card:'.freeze

  def withdraw_money
    @account_manager.print_card_variant
    puts WITHDRAW_REQUEST
    puts Constants::EXIT_PROMPT
    answer = gets.chomp
    return if answer == Constants::EXIT

    current_card = @account_manager.card_by_index(answer)
    puts WITHDRAW_AMOUNT_REQUEST
    current_card.withdraw(gets.chomp.to_i)
    @account_manager.update
  rescue NotEnoughMoney,
         InputCorrectAmount,
         WrongCardNumber,
         NoActiveCardsError => e
    puts e.message
  end

  def put_money
    @account_manager.print_card_variant
    puts CHOOSE_CARD_REQUEST
    puts Constants::EXIT_PROMPT
    answer = gets.chomp
    return if answer == Constants::EXIT

    current_card = @account_manager.card_by_index(answer)
    puts PUT_AMOUNT_REQUEST

    current_card.put(gets.chomp.to_i)
    @account_manager.update
  rescue InputCorrectAmount,
         TaxIsHigherThanAmountError,
         NoActiveCardsError,
         WrongCardNumber => e
    puts e.message
  end

  def sender_card
    puts SEND_CARD_REQUEST
    @account_manager.print_card_variant
    puts Constants::EXIT_PROMPT
    gets.chomp
  end

  def send_money
    answer = sender_card
    return if answer == Constants::EXIT

    sender_card = @account_manager.card_by_index(answer)
    puts RECIPIENT_CARD_REQUEST
    recipient_card = find_card_by_number(gets.chomp)
    puts SEND_AMOUNT_REQUEST
    sender_card.send_money(gets.chomp.to_i, recipient_card)

    @account_manager.update
  rescue CardDoesNotExist,
         TaxIsHigherThanAmountError,
         NoActiveCardsError,
         WrongCardNumber,
         InputCorrectAmount => e
    puts e.message
  end
end
