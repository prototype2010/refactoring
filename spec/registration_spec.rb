
RSpec.describe Registration do
  subject(:registration) { described_class.new }

  context 'when successful registration' do
    let(:name) { 'Boris' }
    let(:age) { '26' }
    let(:login) { 'boriska2626' }
    let(:password) { 'password' }
    let(:commands) { [name, age, login, password] }

    before do
      allow(registration).to receive_message_chain(:gets, :chomp).and_return(*commands)
    end

    it 'requests name' do
      expect { registration.start }.to output(/#{Registration::NAME_REQUEST}/).to_stdout
    end

    it 'requests age' do
      expect { registration.start }.to output(/#{Registration::AGE_REQUEST}/).to_stdout
    end

    it 'requests login' do
      expect { registration.start }.to output(/#{Registration::LOGIN_REQUEST}/).to_stdout
    end

    it 'requests password' do
      expect { registration.start }.to output(/#{Registration::PASSWORD_REQUEST}/).to_stdout
    end

    it 'returns valid object' do
      expect(registration.start).to be_an_instance_of(described_class)
    end

    it 'returns valid name' do
      registration_object = registration.start

      expect(registration_object.name).to be(name)
    end

    it 'returns valid age' do
      registration_object = registration.start

      expect(registration_object.age).to be(age.to_i)
    end

    it 'returns valid login' do
      registration_object = registration.start

      expect(registration_object.login).to be(login)
    end

    it 'returns valid password' do
      registration_object = registration.start

      expect(registration_object.password).to be(password)
    end

    it 'returns empty errors array' do
      registration_object = registration.start

      expect(registration_object.errors).to eq([])
    end
  end

  context 'when unsuccessful registration' do
    let(:name) { '' }
    let(:age) { 'ZZ' }
    let(:login) { '' }
    let(:password) { '' }
    let(:commands) { [name, age, login, password] }

    before do
      allow(registration).to receive_message_chain(:gets, :chomp).and_return(*commands)
    end

    it 'prints name errors' do
      [Registration::ACCOUNT_VALIDATION_PHRASES[:name][:first_letter]].each do |error_message|
        expect { registration.start.print_errors }.to output(/#{error_message}/).to_stdout
      end
    end

    it 'prints password errors' do
      [
        Registration::ACCOUNT_VALIDATION_PHRASES[:password][:present],
        Registration::ACCOUNT_VALIDATION_PHRASES[:password][:longer]
      ].each do |error_message|
        expect { registration.start.print_errors }.to output(/#{error_message}/).to_stdout
      end
    end

    it 'prints login errors' do
      [
        Registration::ACCOUNT_VALIDATION_PHRASES[:login][:present],
        Registration::ACCOUNT_VALIDATION_PHRASES[:password][:longer],
        Registration::ACCOUNT_VALIDATION_PHRASES[:password][:exists]
      ].each do |error_message|
        expect { registration.start.print_errors }.to output(/#{error_message}/).to_stdout
      end
    end

    it 'prints age errors' do
      [
        Registration::ACCOUNT_VALIDATION_PHRASES[:age][:length]
      ].each do |error_message|
        expect { registration.start.print_errors }.to output(/#{error_message}/).to_stdout
      end
    end

    context 'when unsuccessful registration with other errors' do
      let(:name) { 'X' * 50 }
      let(:age) { 'ZZ' }
      let(:login) { 'X' * 50 }
      let(:password) { 'X' * 50 }
      let(:commands) { [name, age, login, password] }

      before do
        allow(registration).to receive_message_chain(:gets, :chomp).and_return(*commands)
      end

      it 'prints login errors' do
        expect do
          registration.start.print_errors
        end.to output(/#{Registration::ACCOUNT_VALIDATION_PHRASES[:login][:shorter]}/).to_stdout
      end

      it 'prints password errors' do
        expect do
          registration.start.print_errors
        end.to output(/#{Registration::ACCOUNT_VALIDATION_PHRASES[:password][:shorter]}/).to_stdout
      end
    end

    context 'when unsuccessful registration when login exists' do
      let(:name) { 'X' * 50 }
      let(:age) { 'ZZ' }
      let(:login) { 'X' * 50 }
      let(:password) { 'X' * 50 }
      let(:commands) { [name, age, login, password] }

      before do
        allow(registration).to receive_message_chain(:gets, :chomp).and_return(*commands)
        allow(registration).to receive(:login_exists?).and_return(true)
      end

      it 'prints login errors' do
        expect { registration.start.print_errors }.to output(/#{Registration::ACCOUNT_VALIDATION_PHRASES[:login][:exists]}/).to_stdout
      end
    end
  end
end
