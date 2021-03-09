class BaseCard
  attr_reader :number, :type, :balance, :tax

  def initialize(tax)
    @tax = tax
    @type = nil
    @balance = 0.00
    @number = 16.times.map { rand(10) }.join
  end

  def resolve_tax_by_type(tax_type, amount)
    tax = @tax.public_send(tax_type)

    case tax
    when FixedTax
      tax.value
    when PercentageTax
      tax.value * amount
    else raise "Unknown tax type #{tax}"
    end
  end

  def withdraw_tax(amount)
    resolve_tax_by_type(:withdraw, amount)
  end

  def withdraw(amount)
    raise 'Not a number' unless amount.is_a? Numeric
    raise InputCorrectAmount if amount.negative?
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
    raise InputCorrectAmount if amount <= 0
    raise 'Not a number' unless amount.is_a? Numeric

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

  def send(amount, card)
    raise 'Not a number' unless amount.is_a? Numeric
    raise InputCorrectAmount if amount <= 0
    raise NotEnoughMoney unless send_possible?(amount)
    raise NotEnoughMoney unless card.put_possible?(amount)

    raise 'Not instance of card' unless card.class.ancestors.include?(BaseCard)

    @balance = @balance - amount - send_tax(amount)

    card.put(amount)

    puts "Money #{amount} was put on #{card.number}. Balance: #{balance}. Tax: #{send_tax(amount)}$\n"
  end

  def to_yaml
    {
      tax: @tax,
      type: @type,
      balance: @balance,
      number: @number
    }
  end
end
