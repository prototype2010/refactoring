RSpec.describe BankTerminal do
  subject(:terminal) { described_class.new }

  let(:registration) do
    instance_double('Registration',
                    name: 'Boris',
                    age: 45,
                    password: 'thepassword',
                    login: 'thelogin',
                    errors: [])
  end
  let(:account) { Account.new(registration) }

  before do
    allow(terminal).to receive(:exit)
  end

  context 'when exit is possible' do
    let(:commands) { ['exit'] }

    before do
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
    end

    it 'says hello' do
      expect { terminal.start }
        .to output(/Hello, we are RubyG bank/).to_stdout
    end
  end

  context 'when create account' do
    let(:commands) { %w[create Boris 45 thelogin thepassword exit] }

    before do
      allow_any_instance_of(Registration).to receive(:start).and_return(registration)
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
    end

    it 'create account is possible' do
      expect { terminal.start }
        .to output(/Welcome, Boris/).to_stdout
    end
  end

  context 'when load account' do
    let(:commands) { %w[load thelogin thepassword exit] }

    before do
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
      allow(terminal).to receive(:find_account).with('thelogin', 'thepassword').and_return(account)
    end

    it 'create account is possible' do
      expect { terminal.start }
        .to output(/Welcome, Boris/).to_stdout
    end
  end

  context 'when create first account' do
    let(:commands) { %w[load y thelogin thepassword exit] }

    before do
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
      allow_any_instance_of(Registration).to receive(:start).and_return(registration)
      allow(terminal).to receive(:accounts).and_return([])
      allow(terminal).to receive(:find_account).with('thelogin', 'thepassword').and_return(account)
    end

    it 'create first account is possible' do
      expect { terminal.start }
        .to output(/Welcome, Boris/).to_stdout
    end
  end

  context 'when show commands card work' do
    let(:commands) { %w[SC exit] }

    before do
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
      account.create_card(Constants::CARD_TYPES[:CAPITALIST])
      terminal.instance_variable_set(:@current_account, account)
    end

    it 'prints cards list' do
      expect { terminal.main_menu }
        .to output(/#{account.cards.first.number}/).to_stdout
    end
  end

  context 'when put money works from menu' do
    let(:commands) { %w[PM exit] }

    before do
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
      account.create_card(Constants::CARD_TYPES[:CAPITALIST])
      terminal.instance_variable_set(:@current_account, account)
    end

    it 'prints cards list' do
      expect { terminal.main_menu }
        .to output(/Choose the card for putting:/).to_stdout
    end
  end

  context 'when withdraw money works from menu' do
    let(:commands) { %w[WM exit] }

    before do
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
      account.create_card(Constants::CARD_TYPES[:CAPITALIST])
      terminal.instance_variable_set(:@current_account, account)
    end

    it 'prints cards list' do
      expect { terminal.main_menu }
        .to output(/Choose the card for withdrawing/).to_stdout
    end
  end

  context 'when send money works from menu' do
    let(:commands) { %w[SM exit] }

    before do
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
      account.create_card(Constants::CARD_TYPES[:CAPITALIST])
      terminal.instance_variable_set(:@current_account, account)
    end

    it 'prints cards list' do
      expect { terminal.main_menu }
        .to output(/Choose the card for sending/).to_stdout
    end
  end

  context 'when destroy account works from menu' do
    let(:commands) { %w[DA NO exit] }

    before do
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
      account.create_card(Constants::CARD_TYPES[:CAPITALIST])
      terminal.instance_variable_set(:@current_account, account)
    end

    it 'prints cards list' do
      expect { terminal.main_menu }
        .to output(/Are you sure you want to destroy account/).to_stdout
    end
  end

  context 'when create card works from menu' do
    let(:commands) { %w[CC virtual exit] }

    before do
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
      account.create_card(Constants::CARD_TYPES[:CAPITALIST])
      terminal.instance_variable_set(:@current_account, account)
    end

    it 'prints cards list' do
      expect { terminal.main_menu }
        .to output(/You could create one of 3 card types/).to_stdout
    end
  end

  context 'when destroy card works from menu' do
    let(:commands) { %w[DC 1 y exit] }

    before do
      allow(terminal).to receive_message_chain(:gets, :chomp).and_return(*commands)
      account.create_card(Constants::CARD_TYPES[:CAPITALIST])
      terminal.instance_variable_set(:@current_account, account)
    end

    it 'prints cards list' do
      expect { terminal.main_menu }
        .to output(/Are you sure you want to delete #{account.cards.first.number}/).to_stdout
    end
  end
end
