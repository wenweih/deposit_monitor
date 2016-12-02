module DepositMonitor

  class << self
    attr_accessor :configuration
  end

  def self.configure
    configuration || Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :host
    attr_accessor :user
    def initialize
      @host = "127.0.0.1:5672"
      @user = "hww:hwwhww"
    end
  end

end
