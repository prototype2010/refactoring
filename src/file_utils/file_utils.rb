module FileUtils
  FILE_PATH = 'accounts.yml'.freeze

  def accounts
    if File.exist?(FILE_PATH)
      YAML.load_file(FILE_PATH)
    else
      []
    end
  end

  def login_exists?(login)
    accounts.map(&:login).include?(login)
  end

  def find_account(login, password)
    found_account = accounts.find { |account| account.login == login && account.password == password }

    puts 'There is no account with given credentials' unless found_account

    found_account
  end

  def update_account_info(account)
    rest_accounts = accounts.reject { |acc| acc.login == account.login }

    save(rest_accounts.push(account))
  end

  def find_card_by_number(card_number)
    raise WrongCardFormat if card_number.length != 16

    found_card = accounts.map(&:cards)
                         .flatten
                         .find { |card| card[:number] == card_number }

    raise CardDoesNotExist if found_card.nil?

    found_card
  end

  def save(accounts)
    File.open(FILE_PATH, 'w') { |f| f.write(accounts.to_yaml) }
  end

  def delete_account(account)
    save(accounts.reject { |acc| acc.login == account.login })
  end
end
