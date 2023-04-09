class TradeError < StandardError
    def initialize(msg="Trade error.")
        super(msg)
      end
end