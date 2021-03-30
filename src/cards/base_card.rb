class BaseCard
  include Validator

  attr_reader :number, :type, :balance, :tax

  CARD_LENGTH = 16

  def initialize(tax)
    @tax = tax
    @type = nil
    @balance = 0.00
    @number = CARD_LENGTH.times.map { rand(10) }.join
  end

  def resolve_tax_by_type(tax_type, amount)
    tax = @tax.public_send(tax_type)

    case tax
    when FixedTax then tax.value
    when PercentageTax then tax.value * amount
    else raise "Unknown tax type #{tax}"
    end
  end

  def withdraw_tax(amount)
    resolve_tax_by_type(:withdraw, amount)
  end

  def withdraw(amount)
    validate_amount(amount)
    raise NotEnoughMoney unless withdraw_possible?(amount)

    @balance -= (amount + withdraw_tax(amount))

    puts "Money #{amount} withdrawed from #{number}$. Money left: #{balance}$. Tax: #{withdraw_tax(amount)}$"
  end

  def withdraw_possible?(amount)
    @balance >= (amount + withdraw_tax(amount))
  end

  def put_possible?(amount)
    put_tax(amount) <= @balance
  end

  def put_tax(amount)
    resolve_tax_by_type(:put, amount)
  end

  def put(amount)
    validate_amount(amount)
    raise TaxIsHigherThanAmountError unless put_possible?(amount)

    @balance += (amount - put_tax(amount))

    puts "Money #{amount} was put on #{number}. Balance: #{balance}. Tax: #{put_tax(amount)}"
  end

  def send_tax(amount)
    resolve_tax_by_type(:sender, amount)
  end

  def send_possible?(amount)
    (send_tax(amount) + amount) <= @balance
  end

  def send_money(amount, card)
    validate_amount(amount)
    validate_send(card, amount)

    @balance = @balance - amount - send_tax(amount)

    card.put(amount)
    puts "Money #{amount} was put on #{card.number}. Balance: #{balance}. Tax: #{send_tax(amount)}$\n"
  end

  def to_hash
    {
      tax: @tax,
      type: @type,
      balance: @balance,
      number: @number
    }
  end
end
