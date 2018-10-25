require 'rspec'
require 'game'
require 'board'

describe Game do
  before(:each) do
    @game = Game.new()
  end

  it "has a ready state and current player when initialised" do
    expect(@game.state).to eq :ready
    expect(@game.current_player).to eq :player_one
  end

  it "allows tokens to be placed on a board" do
    game = @game.make_move(:player_one, 1)
    expect(game.state).to eq :ok
    expect(game.board_state).to eq [Board::PLAYER_ONE].fill(Board::AVAILABLE_POSITION, 1, 8)
    expect(game.available_positions).to eq [*2..9]
  end

  it "does not allow tokens to be placed on top of other tokens" do
    game = @game.make_move(:player_one, 1)
    game = game.make_move(:player_two, 1)
    expect(game.state).to eq :position_taken
    expect(game.board_state).to eq [Board::PLAYER_ONE].fill(Board::AVAILABLE_POSITION, 1, 8)
    expect(game.available_positions).to eq [*2..9]
  end

  [-1, 10, "a", "A", "pos", "£", " ", "", nil].each do |position|
    it "does not allow tokens to be placed in #{position}" do
      game = @game.make_move(:player_one, position)
      expect(game.state).to eq :invalid_position
    end
  end

  it "after one move player two is the current player" do
    game = @game.make_move(:player_one, 1)
    expect(game.current_player).to eq :player_two
  end

  it "after player one and two make a move player one is the current player" do
    game = @game.make_move(:player_one, 1)
    game = game.make_move(:player_two, 2)
    expect(game.current_player).to eq :player_one
  end

  it "correctly places player twos token on the board" do
    game = @game.make_move(:player_one, 1)
    game = game.make_move(:player_two, 2)
    expect(game.board_state).to eq [Board::PLAYER_ONE, Board::PLAYER_TWO].fill(Board::AVAILABLE_POSITION, 2, 7)
    expect(game.available_positions).to eq [*3..9]
  end

  it "does not let an invalid player make a move" do
    game = @game.make_move(:bad_player, 1)
    expect(game.state).to eq :invalid_player
  end

  it "is still a player's turn after bad move" do
    game = @game.make_move(:player_one, "BAD")
    expect(game.current_player).to eq :player_one
  end

  it "does not let the wrong player make a move" do
    game = @game.make_move(:player_one, 1)
    game = game.make_move(:player_one, 2)
    expect(game.state).to eq :wrong_player
  end

  it "returns the status and result of the game" do
    [
      [:player_one, 1],
      [:player_two, 2],
      [:player_one, 3],
      [:player_two, 5],
      [:player_one, 4],
      [:player_two, 7],
      [:player_one, 9],
      [:player_two, 6],
      [:player_one, 8]
    ].each { |move| @game = @game.make_move(move[0], move[1]) }
    expect(@game.state).to eq :game_over
    expect(@game.result).to eq :tie
  end
end
