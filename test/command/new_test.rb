require_relative '../test_helper'
require 'tumugi/command/new'

class Tumugi::Command::NewTest < Test::Unit::TestCase
  setup do
    @cmd = Tumugi::Command::New.new
  end

  sub_test_case '#execute' do
    test 'plugin' do
      output_path = './tmp/test_command_new_execute_plugin'
      @cmd.execute('plugin', 'test', path: output_path)

      generator = Tumugi::Command::New::PluginGenerator.new('test', path: output_path)
      generator.templates.each do |template|
        assert_true(File.exist?("#{output_path}/tumugi-plugin-test/#{template[1]}"))
      end
    end

    test 'project' do
      output_path = './tmp/test_command_new_execute_project'
      @cmd.execute('project', 'test', path: output_path)

      generator = Tumugi::Command::New::ProjectGenerator.new('test', path: output_path)
      generator.templates.each do |template|
        assert_true(File.exist?("#{output_path}/test/#{template[1]}"))
      end
    end

    test 'raise error for unsupported type' do
      assert_raise(Tumugi::TumugiError) do
        @cmd.execute('unsupported', 'test', {})
      end
    end
  end
end
