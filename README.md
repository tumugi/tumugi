[![Build Status](https://travis-ci.org/tumugi/tumugi.svg)](https://travis-ci.org/tumugi/tumugi) [![Code Climate](https://codeclimate.com/github/tumugi/tumugi/badges/gpa.svg)](https://codeclimate.com/github/tumugi/tumugi) [![Coverage Status](https://coveralls.io/repos/tumugi/tumugi/badge.svg?branch=master&service=github)](https://coveralls.io/github/tumugi/tumugi?branch=master)

# Tumugi

Tumugi is a ruby library to build, run and manage complex workflows. Tumugi enables you to define workflows as a ruby code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tumugi'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install tumugi
```

## Usage

![Alt text](http://g.gravizo.com/g?
  digraph G {
    rankdir=LR;
    Task2 -> Task1
    Task3 -> Task1;
    Task4 -> Task2;
    Task4 -> Task3;
  }
)

You can define workflow above as ruby code:

```rb
task :task1 do |t|
  t.requires [:task2, :task3]
  t.run { puts 'task1#run' }
end

task :task2 do |t|
  t.requires [:task4]
  t.run { puts 'task2#run' }
end

task :task3 do |t|
  t.requires [:task4]
  t.run { puts 'task3#run' }
end

task :task4 do |t|
  # You can use do ... end style
  t.run do
    puts 'task4#run'
    sleep 3
  end
end
```

Save these code into `workflow.rb`,
then run this script by `tumugi` command like this:

```bash
$ tumugi workflow.rb task1
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tumugi/tumugi

## License

The gem is available as open source under the terms of the [Apache License
Version 2.0](http://www.apache.org/licenses/).
