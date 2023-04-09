class TradeError < StandardError
    def message
      "Saldo insuficiente."
    end
end