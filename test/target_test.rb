require_relative './test_helper'
require 'tumugi/target'

class Tumugi::TargetTest < Test::Unit::TestCase
  test '#exist? should raise NotImplementedError' do
    assert_raise(NotImplementedError) do
      Tumugi::Target.new.exist?
    end
  end
end
