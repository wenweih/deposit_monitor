module DepositMonitor
  class Monitor
    class << self
      def bunny
        conn = Bunny.new( :host => "192.168.102.2", :port => "5672", :user => "hww", :password => "hwwhww", :automatically_recover => false)
        conn.start
        ch = conn.create_channel
        # get or create exchange
        ethereum_exchange = ch.fanout("ethereum.exchange", durable: true)

        # get or create queue (note the durable setting)
        ethereum_queue = ch.queue("deposit.ethereum", durable: true, auto_delete: false)

        # bind queue to exchange
        ethereum_queue.bind(ethereum_exchange)

        ethereum
        addresses = File.readlines("../tmp/contract_address.csv")
        contract_source = File.read("../tmp/SmartExchange.sol")
        compiled = @ethereum_client.compile_solidity contract_source
        contract = compiled["SmartExchange"]["info"]["abiDefinition"]

        init = Ethereum::Initializer.new("../tmp/SmartExchange.sol", @ethereum_client)
        init.build_all
        contract_instance = SmartExchange.new

        addresses.each do |address|
          contract_instance.at(address)
        end

        conn.close
      end

      def ethereum
        @ethereum_client ||= Ethereum::HttpClient.new("192.168.202.2","8545")
      end
    end
  end
end
