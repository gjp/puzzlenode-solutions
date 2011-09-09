require './circuits'

describe "Logic" do
  require './logic'
  include Logic

  it "should reduce wires" do
    logic_for_wire(' 0---| ').should == '     0 '
  end

  it "should reduce bulbs" do
    logic_for_bulbs(' 0---@ ').should == '   off '
    logic_for_bulbs(' 1---@ ').should == '    on '
  end

  it "should reduce NOT gates" do
    logic_for_gates('0N ').should == ' 1 '
    logic_for_gates('1N ').should == ' 0 '
  end

  it "should reduce AND gates" do
    logic_for_gates('0A0').should == ' 0 '
    logic_for_gates('0A1').should == ' 0 '
    logic_for_gates('1A0').should == ' 0 '
    logic_for_gates('1A1').should == ' 1 '
  end

  it "should reduce OR gates" do
    logic_for_gates('0O0').should == ' 0 '
    logic_for_gates('0O1').should == ' 1 '
    logic_for_gates('1O0').should == ' 1 '
    logic_for_gates('1O1').should == ' 1 '
  end

  it "should reduce XOR gates" do
    logic_for_gates('0X0').should == ' 0 '
    logic_for_gates('0X1').should == ' 1 '
    logic_for_gates('1X0').should == ' 1 '
    logic_for_gates('1X1').should == ' 0 '
  end

  it "should correctly pad output after reduction" do
    logic_for_gates(' 0||N ').should == '    1 '
    logic_for_gates(' 0||A||||0 ').should == '    0      '
  end
end

describe "Circuits" do
  c = Circuits.new('simple_circuits.txt')
  
  it "should build diagrams" do
    c.diagrams[0].should == '0-------------|                          '
  end

  it "should rotate the diagrams" do
    c.transpose_diagrams
    c.diagrams[0].should == '0  1 0 1 1  0 1 1 1'
    c.transpose_diagrams
    c.diagrams[0].should == '0-------------|                          '
  end

  it "should know when to stop solving" do
    c.done?.should == false
    d = c.diagrams
    c.diagrams = ['on','off']
    c.done?.should == true
    c.diagrams = d
  end

  it "should remove whitespace from diagrams" do
    d = c.diagrams
    c.diagrams = ['    ', '  on  ', '    ']
    c.remove_whitespace
    c.diagrams.should == ['on']
    c.diagrams = d
  end

  it "should solve circuits" do
    c.solve
    c.diagrams.should == ["on", "off", "on"]
  end
  
  it "should solve complex circuits" do
    hard = Circuits.new('complex_circuits.txt')
    hard.solve
    hard.diagrams.should == ["on", "on", "on", "off", "off", "on", "on", "off"]
  end
end
