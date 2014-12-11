class Card
  SYMBOLS = ['AH','2D','JC','QS','8D','4H']
  FLIPPED_DOWN_STATE = 0
  FLIPPED_UP_STATE = 1
  DEFAULT_STATE = FLIPPED_DOWN_STATE

  def initialize(symbol)
    @symbol = symbol
    @state = DEFAULT_STATE
  end

  def self.random_card
    random_symbol = SYMBOLS[ rand(0..SYMBOLS.size) ]
    Card.new(random_symbol)
  end

  def flip!
    if !@state.nil?
      @state = ((@state == FLIPPED_UP_STATE) ? FLIPPED_DOWN_STATE : FLIPPED_UP_STATE)
    end
  end

  # def check_symbol
  #   if self.symbol.nil?
  #     false
  #   else
  #     SYMBOLS.include?(self.symbol)
  #   end
  # end

  
end