RSpec.describe Account do
  subject(:account) { described_class.new(registration) }

  let(:registration) do
    instance_double('Registration',
                    name: 'Boris',
                    age: 45,
                    password: 'asdasd',
                    login: 'Boris4565')
  end

  before do
    allow(account).to receive(:update_account_info)
  end

  it 'capitalist card can be created' do
    account.create_card('capitalist')

    expect(account.cards.first).to be_instance_of(CapitalistCard)
  end

  it 'usual card can be created' do
    account.create_card('usual')

    expect(account.cards.first).to be_instance_of(UsualCard)
  end

  it 'virtual card cannot be created' do
    expect { account.create_card(nil) }.to raise_error(WrongCardTypeError)
  end

  it 'virtual card can be created' do
    account.create_card('virtual')

    expect(account.cards.first).to be_instance_of(VirtualCard)
  end

  it 'virtual card can be deleted' do
    account.create_card('virtual')
    account.destroy_card(1)

    expect(account.cards).to eq([])
  end

  it 'virtual card is printed' do
    account.create_card('virtual')
    card = account.cards.first

    expect { account.print_card_variant }.to output(/#{card.number}/).to_stdout
  end

  it 'card by index can be received' do
    account.create_card('virtual')
    account.create_card('capitalist')

    expect(account.card_by_index(2)).to be_instance_of(CapitalistCard)
  end

  it 'card by index raises error' do
    account.create_card('virtual')
    account.create_card('capitalist')

    expect { account.card_by_index(3) }.to raise_error(WrongCardNumber)
  end

  it 'raises error when no cards' do
    expect { account.print_card_variant }.to raise_error(NoActiveCardsError)
  end

  it 'self destructs well' do
    allow(account).to receive(:delete_account).and_return(true)

    expect(account.self_destruct).to eq(true)
  end
end
