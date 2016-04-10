require 'test_helper'

class Tumugi::Target::BaseTest < Test::Unit::TestCase
  test '#exist? should raise NotImplementedError' do
    assert_raise(NotImplementedError) do
      Tumugi::Target::Base.new.exist?
    end
  end
end
