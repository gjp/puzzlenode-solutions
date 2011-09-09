require './turtle'

describe "Turtle" do
  t = Turtle.new(61)
  
  it "should initialize" do
    t.facing.should == 0
    t.position.should == [30,30]
  end

  it "should draw lines" do
    t.draw_line([0,0],[10,0])
    t.draw_line([10,0],[10,10])
    t.draw_line([10,10],[0,10])
    t.draw_line([0,10],[0,0])
    t.draw_line([0,0],[10,10])
    t.draw_line([10,0],[0,10])
    t.canvas.at(0,0).should == 'X'
    t.canvas.at(1,1).should == 'X'
    t.canvas.at(5,0).should == 'X'
    t.canvas.at(5,5).should == 'X'
    t.canvas.at(2,8).should == 'X'
    t.canvas.at(10,10).should == 'X'
  end

  it "should turn right" do
    t.turn_right(135)
    t.facing.should == 135
  end

  it "should move forward" do
    t.move_forward(10)
    t.position.should == [40,40]
  end

  it "should turn left" do
    t.turn_left(45)
    t.facing.should == 90
  end

  it "should move backward" do
    t.move_backward(5)
    t.position.should == [35,40]
  end

end

describe "Canvas" do
  c = Canvas.new(11)
  it "should initialize" do
    c.at(0,0).should == '.'
  end
end

describe "TurtleController" do
  before(:all) do
    @t = TurtleController.new('simple.logo')
  end

  it "should initialize" do
    @t.canvas_size.should == 61
    @t.commands.first.should == 'RT 135'
    @t.commands.last.should == 'FD 20'
  end

  it "should run single commands" do
    @t.move_turtle('RT', 135)
    @t.turtle.facing.should == 135
    @t.move_turtle('FD', 10)
    @t.turtle.position.should == [40,40]
    @t.turtle.canvas.at(35,35).should == 'X'
  end

  it "should run multiple commands" do
    @t.commands = ['RT 135', 'FD 10']
    @t.run_commands
    @t.turtle.canvas.at(35,35).should == 'X'
  end
end
