require 'yaml'
require 'pry'

require_relative './constants'

require_relative './taxes/base_tax'
require_relative './taxes/fixed_tax'
require_relative './taxes/percentage_tax'

require_relative './terminal_menu'

require_relative './exceptions/input_correct_amount'
require_relative './exceptions/not_enough_money'
require_relative './exceptions/wrong_card_number'
require_relative './exceptions/wrong_card_type_error'
require_relative './exceptions/no_active_cards_error'
require_relative './exceptions/tax_is_higher_than_amount_error'
require_relative './exceptions/wrong_card_format'
require_relative './exceptions/card_does_not_exist'

require_relative './taxes/base_card_tax'
require_relative './taxes/capitalist_card_tax'
require_relative './taxes/usual_card_tax'
require_relative './taxes/virtual_card_tax'

require_relative './accounts_register'
require_relative './account_management'

require_relative './registration'
require_relative './transfers'

require_relative './cards/base_card'
require_relative './cards/capitalist_card'
require_relative './cards/virtual_card'
require_relative './cards/cards_factory'
require_relative './cards/usual_card'
require_relative 'account'

require_relative './bank_terminal'
