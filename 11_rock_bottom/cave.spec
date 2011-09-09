require './cave'

describe "Cave" do
  c = Cave.new('simple_cave.txt')

  it 'should initialize' do
    # Subtract 1 for initial water on map
    c.flow_count.should == 99
    c.map[1].join.should == '~                              #'
  end

  it 'should flow water' do
    c.flow
    c.map[1].join.should == '~~~~~~~~~~~~~~~                #'
  end

  it 'should measure water depth' do
    c.measure.should == '1 2 2 4 4 4 4 6 6 6 1 1 1 1 4 3 3 4 4 4 4 5 5 5 5 5 2 2 1 1 0 0'
  end
end
