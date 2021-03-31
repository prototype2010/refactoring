RSpec.describe Transfers do
  subject(:transfer_helper) { TransfersHelper.new }

  let(:registration) do
    instance_double('Registration',
                    name: 'Boris',
                    age: 45,
                    password: 'asdasd',
                    login: 'Boris4565')
  end

  context 'when withdraw money' do
    context 'when successful' do
      let(:account) { Account.new(registration) }
      let(:card_number) { '1' }
      let(:withdraw_amount) { 90 }
      let(:commands) { [card_number, withdraw_amount] }
      let(:account_manager) { AccountManagement.new(account) }

      before do
        account_manager.create_card('capitalist')
        allow(account_manager).to receive(:update_account_info)
        allow(transfer_helper).to receive_message_chain(:gets, :chomp).and_return(*commands)
        transfer_helper.account_manager = account_manager
      end

      it 'choose card requested' do
        expect { transfer_helper.withdraw_money }
          .to output(/#{Transfers::WITHDRAW_REQUEST}/).to_stdout
      end

      it 'withdraw amount requested' do
        expect { transfer_helper.withdraw_money }
          .to output(/#{Transfers::WITHDRAW_AMOUNT_REQUEST}/).to_stdout
      end

      it 'withdraw prints success message' do
        expect { transfer_helper.withdraw_money }
          .to output(/Money #{withdraw_amount} withdrawed from #{account.cards.first.number}/).to_stdout
      end

      it 'balance is decreased' do
        transfer_helper.withdraw_money

        expect(account.cards.first.balance).to be_between(1, 10)
      end
    end

    context 'when failure' do
      context 'when not enough money' do
        let(:account) { Account.new(registration) }
        let(:card_number) { '1' }
        let(:withdraw_amount) { 190 }
        let(:commands) { [card_number, withdraw_amount] }
        let(:account_manager) { AccountManagement.new(account) }

        before do
          account_manager.create_card('capitalist')
          allow(account_manager).to receive(:update_account_info)
          allow(transfer_helper).to receive_message_chain(:gets, :chomp).and_return(*commands)
          transfer_helper.account_manager = account_manager
        end

        it 'withdraw prints error message' do
          expect { transfer_helper.withdraw_money }
            .to output(/#{Transfers::NOT_ENOUGH_MONEY}/).to_stdout
        end
      end
    end
  end

  context 'when put_money' do
    context 'when successful' do
      let(:account) { Account.new(registration) }

      let(:card) { account.cards.first }
      let(:card_number) { '1' }
      let(:put_amount) { 100 }
      let(:commands) { [card_number, put_amount] }
      let(:account_manager) { AccountManagement.new(account) }

      before do
        account_manager.create_card('capitalist')
        allow(account_manager).to receive(:update_account_info)
        allow(transfer_helper).to receive_message_chain(:gets, :chomp).and_return(*commands)
        transfer_helper.account_manager = account_manager
      end

      it 'choose card requested' do
        expect { transfer_helper.put_money }
          .to output(/#{Transfers::CHOOSE_CARD_REQUEST}/).to_stdout
      end

      it 'withdraw amount requested' do
        expect { transfer_helper.put_money }
          .to output(/#{Transfers::PUT_AMOUNT_REQUEST}/).to_stdout
      end

      it 'put prints success message' do
        expected_balance = card.balance + put_amount.to_i - card.put_tax(put_amount)

        expect { transfer_helper.put_money }
          .to output(/Money #{put_amount} was put on #{card.number}. Balance: #{expected_balance}. Tax: #{card.put_tax(put_amount)}/).to_stdout
      end

      it 'balance is increased' do
        transfer_helper.put_money

        expect(account.cards.first.balance).to eq(190)
      end
    end

    context 'when failure' do
      let(:account) { Account.new(registration) }

      let(:card) { account.cards.first }
      let(:card_number) { '1' }
      let(:put_amount) { 'asd' }
      let(:commands) { [card_number, put_amount] }
      let(:account_manager) { AccountManagement.new(account) }

      before do
        account_manager.create_card('capitalist')
        allow(account_manager).to receive(:update_account_info)
        allow(transfer_helper).to receive_message_chain(:gets, :chomp).and_return(*commands)
        transfer_helper.account_manager = account_manager
      end

      it 'print error message' do
        expect { transfer_helper.put_money }
          .to output(/#{Transfers::INCORRECT_SUM}/).to_stdout
      end
    end

    context 'when send money' do
      context 'when successful' do
        let(:account_manager) do
          manager = AccountManagement.new(Account.new(registration))
          manager.create_card('capitalist')
          manager
        end

        let(:card) { account_manager.cards.first }
        let(:card_number) { '1' }
        let(:recipient_card_number) { '1234123412341234' }
        let(:recipient_card) do
          card = CardsFactory.create_card('capitalist')
          card.instance_variable_set(:@number, recipient_card_number)
          card
        end
        let(:put_amount) { '10' }
        let(:commands) { [card_number, recipient_card_number, put_amount] }

        before do
          allow(account_manager).to receive(:update_account_info)
          allow(account_manager).to receive(:save)
          allow(transfer_helper).to receive_message_chain(:gets, :chomp).and_return(*commands)
          allow_any_instance_of(TransfersHelper).to receive(:find_card_by_number)
            .with(recipient_card_number)
            .and_return(recipient_card)
          transfer_helper.account_manager = account_manager
        end

        it 'requests send card' do
          expect { transfer_helper.send_money }
            .to output(/#{Transfers::SEND_CARD_REQUEST}/).to_stdout
        end

        it 'requests card number' do
          expect { transfer_helper.send_money }
            .to output(/#{Transfers::RECIPIENT_CARD_REQUEST}/).to_stdout
        end

        it 'requests send amount' do
          expect { transfer_helper.send_money }
            .to output(/#{Transfers::SEND_AMOUNT_REQUEST}/).to_stdout
        end

        it 'put prints success message' do
          expected_balance = card.balance + put_amount.to_i - card.put_tax(put_amount)

          expect { transfer_helper.send_money }
            .to output(/Money #{put_amount} was put on #{recipient_card_number}. Balance: #{expected_balance}. Tax: #{recipient_card.put_tax(put_amount)}/).to_stdout
        end

        it 'balance is increased' do
          expected_balance = card.balance - put_amount.to_i - card.send_tax(put_amount.to_i)

          transfer_helper.send_money

          expect(card.balance).to eq(expected_balance)
        end
      end
    end
  end
end
