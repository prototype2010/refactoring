class BankTerminal
  include FileUtils
  include Transfers
  include TerminalMenu

  def initialize
    @current_account = nil
  end

  def create
    registration = nil

    loop do
      registration = Registration.new.start
      break if registration.errors.empty?

      registration.print_errors
    end

    new_account = Account.new(registration)
    update_account_info(new_account)

    sign_in(new_account.login, new_account.password)

    main_menu
  end

  def sign_in(login, password)
    @current_account = find_account(login, password)
  end

  def start
    puts 'Hello, we are RubyG bank!'
    puts '- If you want to create account - press `create`'
    puts '- If you want to load account - press `load`'
    puts '- If you want to exit - press `exit`'
    shortcut = get_input.to_sym
    return initial_menu.dig(shortcut, :command).call if initial_menu.key?(shortcut)

    exit
  end

  def load
    loop do
      return create_the_first_account if accounts.empty?

      puts 'Enter your login'
      login = get_input
      puts 'Enter your password'
      password = get_input

      sign_in(login, password)

      break
    end

    main_menu
  end

  def create_the_first_account
    puts 'There is no active accounts, do you want to be the first?[y/n]'
    return create if get_input == 'y'

    start
  end

  def get_input
    gets.chomp
  end
end
