require_relative '../model/user'
require_relative '../model/pocket'
require_relative '../model/mattress'
require_relative '../model/goal'
require_relative '../model/transaction'
require_relative '../model/validators/account_validations'
require_relative '../model/db_conection'

class Account

  attr_accessor :mattress, :pocket, :goal, :transaction

  def initialize(user)
    @id
    @total_balance
    @available_balance
    @user = user
    @transaction
    @account_validations = AccountValidations.new
    @db_conection = DBConection.new
    get_data_db
  end

  def get_data_db
    @db_conection.client.query("SELECT id, total_balance FROM mock_nequi.accounts
      WHERE user_id = #{@user.id}").each do |row|
      @id = row['id']
      @total_balance = row['total_balance']
    end
    set_data_base
    @available_balance = calculate_available_balance
  end

  def show_available_balance
    puts "\nYour available balance: #{@available_balance}\n"
  end

  def show_total_balance
    puts "\nyour total balance: #{@total_balance}\n"
  end

  def deposit_money
    puts "\nhow much money will you deposit: "
    new_money = gets.chomp.to_i
    if new_money > 0
      info_transaction = {
        type: 1,
        money: new_money,
        sender: @user.name,
        receiver: @user.email,
        account_id: @id,
        description_movement_id: 1,
        account_balance: @total_balance
      }
      @transaction.deposit_money
      @total_balance += new_money
      @available_balance += new_money
      puts 'completed transaction'
    else
      puts 'Enter values ​​greater than 0'
    end
  end

  def withdraw_money
    puts '4'
  end

  def send_money
    puts '5'
  end

  def check_transactions
    puts '6'
  end

  private
  def set_data_base
    @mattress = Mattress.new(@id)
    @pocket = Pocket.new(@id)
    @goal = Goal.new(@id)
    @transaction = Transaction.new
  end

  def calculate_available_balance
    @available_balance = @total_balance-@mattress.balance-@pocket.total_balance-@goal.current_balance_total
  end
end
