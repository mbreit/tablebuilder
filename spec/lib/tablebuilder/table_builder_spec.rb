require 'spec_helper'
require 'tablebuilder/table_builder'

describe Tablebuilder::TableBuilder do
  describe '.call_or_self' do
    it 'should return the first argument if it is not callable' do
      Tablebuilder::TableBuilder.call_or_self(:foo).should == :foo
    end

    it 'should call the first argument if it is callable' do
      Tablebuilder::TableBuilder.call_or_self(->{ :foo }).should == :foo
    end

    it 'should use all other arguments as arguments for calling the block' do
      Tablebuilder::TableBuilder.call_or_self(->(*args) { args }, :a, :b).should == [:a, :b]
    end
  end

  describe '.convert_class_element' do
    it 'should return an empty array if the second argument is empty' do
      Tablebuilder::TableBuilder.convert_class_element(:foo, []).should == []
    end

    it 'should return an empty array if the second argument is nil' do
      Tablebuilder::TableBuilder.convert_class_element(:foo, nil).should == []
    end

    it 'should convert the second argument to an array with strings' do
      Tablebuilder::TableBuilder.convert_class_element([], :foo).should == ['foo']
    end

    it 'should call the second argument and convert the result to a string array' do
      Tablebuilder::TableBuilder.convert_class_element([], -> { [:foo, 2] }).should == ['foo', '2']
    end

    it 'should use the first argument as argument array for the second argument' do
      Tablebuilder::TableBuilder.convert_class_element([:foo, 2], ->(*args) { args }).should == ['foo', '2']
    end
  end
end
