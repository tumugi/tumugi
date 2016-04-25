require 'test_helper'
require 'tumugi/tumugi_module'

class Tumugi::TumugiModuleTest < Test::Unit::TestCase
  sub_test_case '#application' do
    test 'returns Tumugi::Application instance' do
      assert_equal(Tumugi::Application, Tumugi.application.class)
    end

    test 'returns same instance when called multiple' do
      assert_same(Tumugi.application, Tumugi.application)
    end
  end
end
