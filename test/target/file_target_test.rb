require 'test_helper'

class Tumugi::Target::FileTargetTest < Test::Unit::TestCase
  sub_test_case '#exist?' do
    setup do
      @file = Tempfile.open('file_target_test')
    end

    teardown do
      @file.close!
    end

    test 'returns true when file exists' do
      target = Tumugi::Target::FileTarget.new(@file.path)
      assert_true(target.exist?)
    end

    test 'returns false when file not exists' do
      target = Tumugi::Target::FileTarget.new('not_exist_file')
      assert_false(target.exist?)
    end
  end
end
