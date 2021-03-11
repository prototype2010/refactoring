class AccountsRegisterHelper
  include AccountsRegister
end

RSpec.describe AccountsRegister do
  subject(:file_util) { AccountsRegisterHelper.new }

  let(:registration) do
    instance_double('Registration',
                    name: 'Boris',
                    age: 45,
                    password: 'thepassword',
                    login: 'thelogin',
                    errors: [])
  end
  let(:account) { Account.new(registration) }
  let(:account_management) { AccountManagement.new(account) }
  let(:card) { account_management.cards.first }
  let(:card_number) { card.number }

  before do
    account_management.create_card(Constants::CARD_TYPES[:CAPITALIST])
    allow(file_util).to receive(:accounts).and_return([account])
  end

  context 'when finding card by number' do
    it 'find card by number is possible' do
      expect(file_util.find_card_by_number(card_number))
        .to eq(card)
    end
  end
end
