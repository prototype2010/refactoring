class BankTerminal
  include AccountsRegister
  include Transfers
  include TerminalMenu

  LOGIN_REQUEST = 'Enter your login'.freeze
  PASSWORD_REQUEST = 'Enter your password'.freeze
  NO_ACTIVE_ACCOUNT_MESSAGE =  'There is no active accounts, do you want to be the first?[y/n]'.freeze
  WELCOME_MESSAGE = 'Hello, we are RubyG bank! \
    - If you want to create account - press `create` \
    - If you want to load account - press `load` \
    - If you want to exit - press `exit`'.freeze

  def initialize
    @account_manager = nil
  end

  def registration
    loop do
      registration_result = Registration.new.start
      return registration_result if registration_result.errors.empty?

      registration_result.print_errors
    end
  end

  def create
    new_account = Account.new(registration)
    update_account_info(new_account)

    sign_in(new_account.login, new_account.password)

    main_menu
  end

  def sign_in(login, password)
    @account_manager = AccountManagement.new(find_account(login, password))
  end

  def start
    puts WELCOME_MESSAGE
    shortcut = input.to_sym

    return initial_menu.dig(shortcut, :command).call if initial_menu.key?(shortcut)

    exit
  end

  def load
    return create_the_first_account if accounts.empty?

    puts LOGIN_REQUEST
    login = input
    puts PASSWORD_REQUEST
    password = input
    sign_in(login, password)
    main_menu
  end

  def create_the_first_account
    puts NO_ACTIVE_ACCOUNT_MESSAGE
    return create if input == Constants::YES

    start
  end

  def input
    gets.chomp
  end
end
