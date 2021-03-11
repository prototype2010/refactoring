RSpec.describe AccountManagement do
  let(:registration) {
    instance_double('Registration',
                    name: 'Boris',
                    age: 45,
                    password: 'asdasd',
                    login: 'Boris4565')
  }

  let(:account) { Account.new(registration) }
  subject(:account_manager) { described_class.new(account) }

  before do
    allow(account_manager).to receive(:update_account_info)
  end

  it 'capitalist card can be created' do
    account_manager.create_card(Constants::CARD_TYPES[:CAPITALIST])

    expect(account_manager.cards.first).to be_instance_of(CapitalistCard)
  end

  it 'usual card can be created' do
    account_manager.create_card(Constants::CARD_TYPES[:USUAL])

    expect(account_manager.cards.first).to be_instance_of(UsualCard)
  end

  it 'virtual card cannot be created' do
    expect { account_manager.create_card(nil) }.to raise_error(WrongCardTypeError)
  end

  it 'virtual card can be created' do
    account_manager.create_card(Constants::CARD_TYPES[:VIRTUAL])

    expect(account_manager.cards.first).to be_instance_of(VirtualCard)
  end

  it 'virtual card can be deleted' do
    account_manager.create_card(Constants::CARD_TYPES[:VIRTUAL])
    account_manager.destroy_card(1)

    expect(account_manager.cards).to eq([])
  end

  it 'virtual card is printed' do
    account_manager.create_card(Constants::CARD_TYPES[:VIRTUAL])
    card = account_manager.cards.first

    expect { account_manager.print_card_variant }.to output(/#{card.number}/).to_stdout
  end

  it 'card by index can be received' do
    account_manager.create_card(Constants::CARD_TYPES[:VIRTUAL])
    account_manager.create_card(Constants::CARD_TYPES[:CAPITALIST])

    expect(account_manager.card_by_index(2)).to be_instance_of(CapitalistCard)
  end

  it 'card by index raises error' do
    account_manager.create_card(Constants::CARD_TYPES[:VIRTUAL])
    account_manager.create_card(Constants::CARD_TYPES[:CAPITALIST])

    expect { account_manager.card_by_index(3) }.to raise_error(WrongCardNumber)
  end

  it 'raises error when no cards' do
    expect { account_manager.print_card_variant }.to raise_error(NoActiveCardsError)
  end

  it 'self destructs well' do
    allow(account_manager).to receive(:delete_account).and_return(true)

    expect(account_manager.self_destruct).to eq(true)
  end
end
