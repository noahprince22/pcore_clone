class Bowling
  def hit(pins)
  end

  def score
    0
  end
end



describe Bowling, "#score" do
  it "returns 0 for all gutter game" do
    bowling = Bowling.new
    20.times { bowling.hit(0) }
    bowling.score.should eq(1)
    puts "alsdkfj2"
  end
end
