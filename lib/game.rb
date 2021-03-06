require 'pry'

class Game


  WIN_COMBINATIONS = [
     [0,1,2],
     [3,4,5],
     [6,7,8],
     [0,3,6],
     [1,4,7],
     [2,5,8],
     [0,4,8],
     [6,4,2],
     ]

   attr_accessor :board, :player_1, :player_2

   def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
     @board = board
     @player_1 = player_1
     @player_2 = player_2
   end

   def current_player
     if board.turn_count % 2 == 0
       @player_1
     else
       @player_2
     end
   end

   def won?
     WIN_COMBINATIONS.detect do |win_combination|
       win_index_1 = win_combination[0]
       win_index_2 = win_combination[1]
       win_index_3 = win_combination[2]
       position_1 = @board.cells[win_index_1]
       position_2 = @board.cells[win_index_2]
       position_3 = @board.cells[win_index_3]
       x_wins = position_1 == "X" && position_2 == "X" && position_3 == "X"
       y_wins = position_1 == "O" && position_2 == "O" && position_3 == "O"
        if x_wins || y_wins
          win_combination
        elsif board.full? && !win_combination
          false
        end
     end
   end

   def draw?
     board.full? && !won?
   end

   def over?
     if draw?
       true
     elsif won?
       true
     end
   end

  def winner
    if won?
      @board.cells[won?[0]]
    end
  end

  def turn
    @board.display
    input = current_player.move(@board) #move takes care of getting the input from the players.  input = gets.strip
    if @board.valid_move?(input)  #if the input is a valid move.
      @board.update(input, current_player)  #It updates the board.
      #binding.pry
    else
      turn  #else, it takes another turn
    end
  end

  def play
    until over?
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
      @board.display
    else
      puts "Cat's Game!"
      @board.display
    end
  end
end
