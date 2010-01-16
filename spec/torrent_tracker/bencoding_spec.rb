require "spec"

describe "Bencoding" do

  it "should encode a string" do
    "string".bencode.should == "6:string"
  end

  it "should encode a numeric" do
    12.0.bencode.should == "i12e"
  end

  it "should encode an integer" do
    14.bencode.should == "i14e"
  end

  it "should encode a symbol" do
    :symbol.bencode.should == "6:symbol"
  end

  it "should encode an array into a list" do
    [:a, "b", 1, 12.0].bencode.should == "l1:a1:bi1ei12ee"
  end

  it "should encode a hash into a dictionary" do
    {:a => :b, :c => "d", :e => 1, :f => 1.0}.bencode.should == "d1:a1:b1:c1:d1:ei1e1:fi1ee"
  end
end