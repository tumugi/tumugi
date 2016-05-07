[![Build Status](https://travis-ci.org/tumugi/tumugi.svg)](https://travis-ci.org/tumugi/tumugi) [![Code Climate](https://codeclimate.com/github/tumugi/tumugi/badges/gpa.svg)](https://codeclimate.com/github/tumugi/tumugi) [![Coverage Status](https://coveralls.io/repos/tumugi/tumugi/badge.svg?branch=master&service=github)](https://coveralls.io/github/tumugi/tumugi?branch=master) [![Gem Version](https://badge.fury.io/rb/tumugi.svg)](https://badge.fury.io/rb/tumugi)

# Tumugi

Tumugi is a ruby library to build, run and manage complex workflows. Tumugi enables you to define workflows as a ruby code.

## Installation

**Tumugi only support Ruby 2.1 and above**

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
task :task1 do
  requires [:task2, :task3]
  run { puts 'task1#run' }
end

task :task2 do
  requires [:task4]
  run { puts 'task2#run' }
end

task :task3 do
  requires [:task4]
  run { puts 'task3#run' }
end

task :task4 do
  # You can use do ... end style
  run do
    puts 'task4#run'
    sleep 3
  end
end
```

Save these code into `workflow.rb`,
then run this script by `tumugi` command like this:

```bash
$ tumugi run -f workflow.rb task1
I, [2016-05-06T22:58:28.271234 #76156]  INFO -- : start: task4
I, [2016-05-06T22:58:28.271310 #76156]  INFO -- : run: task4
I, [2016-05-06T22:58:28.271386 #76156]  INFO -- : task4#run
I, [2016-05-06T22:58:29.276218 #76156]  INFO -- : completed: task4
I, [2016-05-06T22:58:29.276373 #76156]  INFO -- : start: task2
I, [2016-05-06T22:58:29.276437 #76156]  INFO -- : run: task2
I, [2016-05-06T22:58:29.276546 #76156]  INFO -- : task2#run
I, [2016-05-06T22:58:29.276606 #76156]  INFO -- : completed: task2
I, [2016-05-06T22:58:29.276650 #76156]  INFO -- : start: task3
I, [2016-05-06T22:58:29.276688 #76156]  INFO -- : run: task3
I, [2016-05-06T22:58:29.276733 #76156]  INFO -- : task3#run
I, [2016-05-06T22:58:29.276765 #76156]  INFO -- : completed: task3
I, [2016-05-06T22:58:29.276798 #76156]  INFO -- : start: task1
I, [2016-05-06T22:58:29.276823 #76156]  INFO -- : run: task1
I, [2016-05-06T22:58:29.276861 #76156]  INFO -- : task1#run
I, [2016-05-06T22:58:29.276899 #76156]  INFO -- : completed: task1
I, [2016-05-06T22:58:29.278919 #76156]  INFO -- : Result report:
+-------+----------+------------+-----------+
| Task  | Requires | Parameters | State     |
+-------+----------+------------+-----------+
| task1 | task2    |            | completed |
|       | task3    |            |           |
| task3 | task4    |            | completed |
| task2 | task4    |            | completed |
| task4 |          |            | completed |
+-------+----------+------------+-----------+
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tumugi/tumugi

## License

The gem is available as open source under the terms of the [Apache License
Version 2.0](http://www.apache.org/licenses/).
