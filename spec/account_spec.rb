RSpec.describe Account do
  subject { described_class.new(registration) }

  let(:registration) do
    instance_double('Registration',
                    name: 'Boris',
                    age: 45,
                    password: 'asdasd',
                    login: 'Boris4565')
  end

  before do
    allow(subject).to receive(:update_account_info)
  end

  it 'capitalist card can be created' do
    subject.create_card('capitalist')

    expect(subject.cards.first).to be_instance_of(CapitalistCard)
  end

  it 'usual card can be created' do
    subject.create_card('usual')

    expect(subject.cards.first).to be_instance_of(UsualCard)
  end

  it 'virtual card can be created' do
    expect { subject.create_card(nil) }.to raise_error(WrongCardTypeError)
  end

  it 'virtual card can be created' do
    subject.create_card('virtual')

    expect(subject.cards.first).to be_instance_of(VirtualCard)
  end

  it 'virtual card can be deleted' do
    subject.create_card('virtual')
    subject.destroy_card(1)

    expect(subject.cards).to eq([])
  end

  it 'virtual card is printed' do
    subject.create_card('virtual')
    card = subject.cards.first

    expect { subject.print_card_variant }.to output(/#{card.number}/).to_stdout
  end

  it 'card by index can be received' do
    subject.create_card('virtual')
    subject.create_card('capitalist')

    expect(subject.card_by_index(2)).to be_instance_of(CapitalistCard)
  end

  it 'card by index raises error' do
    subject.create_card('virtual')
    subject.create_card('capitalist')

    expect { subject.card_by_index(3) }.to raise_error(WrongCardNumber)
  end

  it 'raises error when no cards' do
    expect { subject.print_card_variant }.to raise_error(NoActiveCardsError)
  end

  it 'self destructs well' do
    allow(subject).to receive(:delete_account).and_return(true)

    expect(subject.self_destruct).to eq(true)
  end
end
