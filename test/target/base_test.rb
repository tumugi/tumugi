require 'test_helper'
require 'tumugi/target/base'

class Tumugi::Target::BaseTest < Test::Unit::TestCase
  test '#exist? should raise NotImplementedError' do
    assert_raise(NotImplementedError) do
      Tumugi::Target::Base.new.exist?
    end
  end
end
