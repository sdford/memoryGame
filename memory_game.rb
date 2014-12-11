class MemoryGame
  require './card.rb'
  @@current_game = nil

  def initialize
    #make sure num of cards is even
    #even num of cols => even num of cards
    @num_rows = 2
    @num_cols = 3

    #make sure num_cards/2 < Card::Symbols.size
    @num_cards = @num_rows * @num_cols
    
    @first_card = nil
    @second_card = nil

    @num_possible_matches = @num_cards/2
    @num_found_matches = 0

    @board = []
  end

  def start_game
    uniq_cards = find_uniq_cards
    make_board(uniq_cards)

    puts "Starting game..."
    print_board
    while !is_game_over?
      start_turn
    end
    puts "You Won!!!"

    puts "Play again? (Y/N)"
    replay = gets.chomp
    if replay.eql?("Y") || replay.eql?("y")
      @@current_game = MemoryGame.new
      @@current_game.start_game
    else
      return
    end
  end

  def start_turn
    puts "Please enter a row (1-#{@board.size})"
    row = (gets.chomp).to_i
    row -= 1

    if 0 <= row && row < @board.size 
      puts "Please enter a col (1-#{@board[row].size})"
      col = (gets.chomp).to_i
      col -= 1

      if 0 <= col && col < @board[row].size
        selected_card = @board[row][col]

        #if first turn
        if @first_card.nil?
          @first_card = selected_card
          @first_card.flip!
          print_board
          return true

        #if second turn
        elsif @second_card.nil?
          if selected_card.instance_variable_get(:@state) == Card::FLIPPED_UP_STATE
            puts "Card already flipped."
            print_board
            return false
          else
            @second_card = selected_card
            @second_card.flip!
            check_similarity
            print_board
            return true
          end
        end
      else
        puts "Invalid col."
        print_board
        return false
      end
    else
      puts "Invalid row."
      print_board
      return false
    end

  end

  def print_board
    print "\n"
    print '['
    @board.each_with_index do |row,r_index|
      print '['
      row.each_with_index do |card,c_index|
        if card.instance_variable_get(:@state) == Card::FLIPPED_UP_STATE
          print card.instance_variable_get(:@symbol)
        elsif card.nil?
          print "nil"
        else
          print 'X'
        end
        if c_index < row.size-1
          print ', '
        end
      end
      print ']'
      if r_index == @board.size-1
        print ']'
      end
      print "\n"
    end
    print "\n"
  end


  private

  def is_new_card?(card,card_arr)
    if card.nil?
      false
    else
      !card_arr.map{ |c| c.instance_variable_get(:@symbol) }
        .include?( card.instance_variable_get(:@symbol) )
    end
  end

  def find_uniq_cards
    puts "shuffling cards..."
    uniq_cards = []
    while uniq_cards.size < (@num_cards / 2)
      card = Card.random_card
      if is_new_card?(card,uniq_cards)
        uniq_cards.push(card)
      end
    end
    uniq_cards
  end

  def make_pairs(cards)
    card_pair_arr = []
    for card in cards
      card_pair_arr.push(card)

      new_card = Card.new(card.instance_variable_get(:@symbol))
      card_pair_arr.push(new_card)
    end
    card_pair_arr
  end

  def make_board(uniq_cards)
    puts "making board..."
    cards = make_pairs(uniq_cards)
    cards.shuffle!

    card_index = 0
    for row_index in (0..@num_rows-1)
      row = []
      for col_index in (0..@num_cols-1)
        row.push(cards[card_index])
        card_index += 1
      end
      @board.push(row)
    end
  end

  def check_similarity
    if !@first_card.nil? && !@second_card.nil?
      if @first_card.instance_variable_get(:@symbol)
        .eql?(@second_card.instance_variable_get(:@symbol))
        puts "Match Found"
        @num_found_matches += 1
        puts "Number of Found Matches: #{@num_found_matches}"
        @first_card = nil
        @second_card = nil
      else
        print_board
        sleep(3)
        @first_card.flip!
        @second_card.flip!
        @first_card = nil
        @second_card = nil
      end
    end
  end

  def is_game_over?
    @num_found_matches == @num_possible_matches
  end
end

game = MemoryGame.new
game.start_game