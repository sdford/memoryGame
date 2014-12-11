class Card
  SYMBOLS = ['AH','2D','JC','QS','8D','4H']
  FLIPPED_DOWN_STATE = 0
  FLIPPED_UP_STATE = 1
  DEFAULT_STATE = FLIPPED_DOWN_STATE

  def self.random_card
    random_symbol = SYMBOLS[ rand(0..SYMBOLS.size) ]
    default_state = DEFAULT_STATE
    Card.new(random_symbol,default_state)
  end

  def flip!
    if !self.state.nil?
      current_state = self.state
      @state = ((current_state == FLIPPED_UP_STATE) ? FLIPPED_DOWN_STATE : FLIPPED_UP_STATE)
    end
  end

  private
  def initialize(symbol, state)
    @symbol = symbol
    @state = state
  end

  # def check_symbol
  #   if self.symbol.nil?
  #     false
  #   else
  #     SYMBOLS.include?(self.symbol)
  #   end
  # end

  
end