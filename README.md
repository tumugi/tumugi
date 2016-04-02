# Tumugi

Tumugi is a ruby library to build, run and manage complex workflows. Tumugi enables you to define workflows as a ruby code.

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

```rb:workflow.rb
task :task1 do
  requires [:task2, :task3]
  run ->{ puts "task_1#run" }
end

task :task2 do
  requires [:task4]
  run ->{ puts "task2#run" }
end

task :task3 do
  requires [:task4]
  run ->{ puts "task3#run" }
end

task :task4 do
  run ->{ puts "task4#run" }
end
```

Then run this script by `tumugi` command like this:

```bash
$ tumugi workflow.rb task_1
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tumugi/tumugi

## License

The gem is available as open source under the terms of the [Apache License
Version 2.0](http://www.apache.org/licenses/).
