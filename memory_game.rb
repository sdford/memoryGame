class MemoryGame
  require './card.rb'

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

    @cards = []
    @board = []

    uniq_cards = []
    while uniq_cards.size < (@num_cards / 2)
      card = Card.random_card
      if is_new_card?(card,uniq_cards)
        uniq_cards.append(card)
      end
    end
    make_board(uniq_cards)
    start_game
  end

  def start_game
    while !is_game_over?
      start_turn
    end
  end

  def start_turn
    print_board

    puts "Please enter a row (1-#{@board.size})"
    row = gets.chomp

    if (1..@board.size+1).include?(row) 
      row -= 1 
      puts "Please enter a col (1-#{@board[row].size}"
      col = gets.chomp

      if (1..@board[row].size+1).include?(col) 
        col -= 1
        selected_card = @board[row][col]

        #if first turn
        if @first_card.nil?
          selected_card.flip!
          @first_card = clicked_card

        #if second turn
        elsif @second_card.nil?
          if selected_card.state == Card::FLIPPED_UP_STATE
            puts "Card already flipped up."
            print_board
            return false
          else
            selected_card.flip!
            check_similarity
          end
        end
        print_board
        return true

      else
        puts "Invalid col."
        return false
      end
    else
      puts "Invalid row."
      return false
    end

  end

  def print_board
    print '['
    for row in @board
      print '['
      for card in row
        if card.state == Card::FLIPPED_UP_STATE
          print card.symbol
        else
          print 'X'
        end
        print ', '
      end
      print ']'
      print "\n"
    end
    print ']'
    print "\n"
  end


  private

  def is_new_card?(card,card_arr)
    card_arr.map{|c| c.symbol}.include?(card.symbol)
  end

  def make_board(uniq_cards)
    @cards = uniq_cards + uniq_cards
    @cards.shuffle!

    card_index = 0
    for row_index in (0..@num_rows)
      row = []
      for col_index in (0..@num_cols)
        row.append(@cards[card_index])
        card_index += 1
      end
      @board.append(row)
    end
  end

  def check_similarity
    if !@first_card.nil? && !@second_card.nil?
      if @first_card.symbol.equals?(@second_card.symbol)
        @first_card = nil
        @second_card = nil
      else
        sleep(3)
        @first_card.flip!
        @second_card.flip!
      end
    end
  end

  def is_game_over?
    @num_found_matches == @num_possible_matches
  end
end

game = MemoryGame.new