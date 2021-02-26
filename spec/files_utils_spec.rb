class FileUtilsHelper
  include FileUtils
end

RSpec.describe FileUtils do
  subject {FileUtilsHelper.new}

  let(:registration) {
    instance_double('Registration',
                    name: 'Boris',
                    age: 45,
                    password: 'thepassword',
                    login: 'thelogin',
                    errors: [],
                    )
  }
  let(:account) {
    new_account = Account.new(registration)
    new_account.create_card('capitalist')

    new_account
  }

  let(:card) {account.cards.first}
  let(:card_number) { card.number }

  before do
    allow(subject).to receive(:accounts).and_return([account])
  end

  context 'finding card by number' do
    it 'find card by number is possible' do
      expect(subject.find_card_by_number(card_number))
        .to eq(card)
    end

  end

end
