require 'game/player'

module Game
  describe Player do
    it "creates a human player" do
      player = Player.create(:human, 'X')
      expect(player.type).to eq :user
    end

    it "creates an easy computer player" do
      player = Player.create(:easy, 'X')
      expect(player.type).to eq :computer
    end

    it "raises an unknown player error when an invalid player is provided" do
      expect { Player.create(:unknown, 'X') }.to raise_exception(RuntimeError, "Unknown player type specified")
    end
  end
end