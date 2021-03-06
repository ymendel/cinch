require File.dirname(__FILE__) + '/helper'

describe "Cinch::Base" do
  before do
    @base = Cinch::Base.new

    @full = Cinch::Base.new(
      :server => 'irc.freenode.org',
      :nick => 'CinchBot',
      :channels => ['#cinch']
    )
  end

  describe "::new" do     
    it "should add a ctcp version listener" do 
      @base.listeners.should include :ctcp
      @base.listeners[:ctcp].should include :version
    end
  end

  describe "#plugin" do 
    it "should compile and add a rule" do
      @base.plugin('foo')
      @base.rules.include?("^foo$").should == true
    end

    it "should add options to an existing rule" do
      @base.plugin('foo') { }
      @base.plugin('foo', :bar => 'baz') { }
      rule = @base.rules.get('^foo$')
      rule.options.should include :bar
    end 

    it "should add its block to an existing rule" do
      @base.plugin('foo') { }
      @base.plugin('foo') { }
      rule = @base.rules.get_rule('^foo$')
      rule.callbacks.size.should == 2
    end
  end

  describe "#on" do
    it "should save a listener" do
      @base.on(:foo) {}
      @base.listeners.should include :foo
    end

    it "should store listener blocks in an Array" do
      @base.listeners[:ping].should be_kind_of Array
    end
  end

  describe "#compile" do
    it "should return an Array of 2 values" do
      ret = @base.compile("foo")
      ret.should be_kind_of(Array)
      ret.size.should == 2
    end
    
    it "should return an empty set of keys if no named parameters are labeled" do
      rule, keys = @base.compile("foo")
      keys.should be_empty
    end

    it "should return a key for each named parameter labeled" do
      rule, keys = @base.compile("foo :bar :baz")
      keys.size.should == 2
      keys.should include "bar"
      keys.should include "baz"
    end

    it "should return a rule of type String, unless Regexp is given" do
      rule, keys = @base.compile(:foo)
      rule.should be_kind_of(String)

      rule, keys = @base.compile(/foo/)
      rule.should be_kind_of(Regexp)
      keys.should be_empty
    end

    it "should convert a custom pattern" do
      @base.add_custom_pattern(:people, "foo|bar|baz")
      rule, keys = @base.compile(":foo-people")
      rule.should == "^(foo|bar|baz)$"    
    end

    it "should automatically add start and end anchors" do
      rule, keys = @base.compile("foo bar baz")
      rule[0].chr.should == "^"
      rule[-1].chr.should == "$"
    end
  end
end

