class TransfersHelper
  include Transfers
  include FileUtils

  attr_accessor :current_account

  def initialize
    @current_account = nil
  end
end

RSpec.describe Transfers do
  TRANSFER_PHRASES = {
    choose_card_withdrawing: 'Choose the card for withdrawing:',
    choose_card_putting: 'Choose the card for putting:',
    choose_card_sending: 'Choose the card for sending:',
    recipient_card: 'Enter the recipient card:',
    withdraw_amount: 'Input the amount of money you want to withdraw',
    send_amount: 'Input the amount of money you want to send',
    put_amount: 'Input the amount of money you want to put on your card',
    not_enough_money: 'You don\'t have enough money on card for such operation',
    incorrect_sum: 'You must input correct amount of money'

  }.freeze

  subject(:transfer_helper) { TransfersHelper.new }

  context 'when withdraw money' do
    context 'when successful' do
      let(:account) do
        account = Account.new(instance_double('Registration',
                                              name: 'Boris',
                                              age: 45,
                                              password: 'asdasd',
                                              login: 'Boris4565'))

        allow(account).to receive(:update_account_info)
        account.create_card('capitalist')

        account
      end

      let(:card_number) { '1' }
      let(:withdraw_amount) { '90' }
      let(:commands) { [card_number, withdraw_amount] }

      before do
        allow(transfer_helper).to receive_message_chain(:gets, :chomp).and_return(*commands)
        transfer_helper.current_account = account
      end

      it 'choose card requested' do
        expect { transfer_helper.withdraw_money }
          .to output(/#{TRANSFER_PHRASES[:choose_card_withdrawing]}/).to_stdout
      end

      it 'withdraw amount requested' do
        expect { transfer_helper.withdraw_money }
          .to output(/#{TRANSFER_PHRASES[:withdraw_amount]}/).to_stdout
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
        let(:account) do
          account = Account.new(instance_double('Registration',
                                                name: 'Boris',
                                                age: 45,
                                                password: 'asdasd',
                                                login: 'Boris4565'))

          allow(account).to receive(:update_account_info)
          account.create_card('capitalist')

          account
        end

        let(:card_number) { '1' }
        let(:withdraw_amount) { '190' }
        let(:commands) { [card_number, withdraw_amount] }

        before do
          allow(transfer_helper).to receive_message_chain(:gets, :chomp).and_return(*commands)
          transfer_helper.current_account = account
        end

        it 'withdraw prints error message' do
          expect { transfer_helper.withdraw_money }
            .to output(/#{TRANSFER_PHRASES[:not_enough_money]}/).to_stdout
        end
      end
    end
  end

  context 'when put_money' do
    context 'when successful' do
      let(:account) do
        account = Account.new(instance_double('Registration',
                                              name: 'Boris',
                                              age: 45,
                                              password: 'asdasd',
                                              login: 'Boris4565'))

        allow(account).to receive(:update_account_info)
        account.create_card('capitalist')

        account
      end

      let(:card) { account.cards.first }
      let(:card_number) { '1' }
      let(:put_amount) { '100' }
      let(:commands) { [card_number, put_amount] }

      before do
        allow(transfer_helper).to receive_message_chain(:gets, :chomp).and_return(*commands)
        transfer_helper.current_account = account
      end

      it 'choose card requested' do
        expect { transfer_helper.put_money }
          .to output(/#{TRANSFER_PHRASES[:choose_card_putting]}/).to_stdout
      end

      it 'withdraw amount requested' do
        expect { transfer_helper.put_money }
          .to output(/#{TRANSFER_PHRASES[:put_amount]}/).to_stdout
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
      let(:account) do
        account = Account.new(instance_double('Registration',
                                              name: 'Boris',
                                              age: 45,
                                              password: 'asdasd',
                                              login: 'Boris4565'))

        allow(account).to receive(:update_account_info)
        account.create_card('capitalist')

        account
      end

      let(:card) { account.cards.first }
      let(:card_number) { '1' }
      let(:put_amount) { 'asd' }
      let(:commands) { [card_number, put_amount] }

      before do
        allow(transfer_helper).to receive_message_chain(:gets, :chomp).and_return(*commands)
        transfer_helper.current_account = account
      end

      it 'print error message' do
        expect { transfer_helper.put_money }
          .to output(/#{TRANSFER_PHRASES[:incorrect_sum]}/).to_stdout
      end
    end

    context 'when send money' do
      context 'when successful' do
        let(:registration) do
          instance_double('Registration',
                          name: 'Boris',
                          age: 45,
                          password: 'asdasd',
                          login: 'Boris4565')
        end
        let(:account) do
          account = Account.new(registration)
          account.create_card('capitalist')
          account
        end

        let(:card) { account.cards.first }
        let(:card_number) { '1' }
        let(:recipient_card_number) { '1234123412341234' }
        let(:recipient_card) do
          card = CapitalistCard.new(CapitalistCardTax.new)
          card.instance_variable_set(:@number, recipient_card_number)
          card
        end
        let(:put_amount) { '10' }
        let(:commands) { [card_number, recipient_card_number, put_amount] }

        before do
          allow(account).to receive(:update_account_info)
          allow(account).to receive(:save)
          allow(transfer_helper).to receive_message_chain(:gets, :chomp).and_return(*commands)
          allow_any_instance_of(TransfersHelper).to receive(:find_card_by_number)
            .with(recipient_card_number)
            .and_return(recipient_card)
          transfer_helper.current_account = account
        end

        it 'requests send card' do
          expect { transfer_helper.send_money }
            .to output(/#{TRANSFER_PHRASES[:choose_card_sending]}/).to_stdout
        end

        it 'requests card number' do
          expect { transfer_helper.send_money }
            .to output(/#{TRANSFER_PHRASES[:recipient_card]}/).to_stdout
        end

        it 'requests send amount' do
          expect { transfer_helper.send_money }
            .to output(/#{TRANSFER_PHRASES[:send_amount]}/).to_stdout
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
