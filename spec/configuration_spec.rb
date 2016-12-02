require "spec_helper"
describe DepositMonitor::Configuration do
  describe ".configure" do
    it "return RabbitMQ host" do
      config = DepositMonitor::Configuration.new
      expect( config.host).to eq("127.0.0.1:5672")
      expect( config.user).to eq("hww:hwwhww")
    end
  end
end
