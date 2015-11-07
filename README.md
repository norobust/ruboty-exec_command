# Ruboty::ExecCommand

Ruboty Exec Command adds the name of external command path as a handler.
You can run your own command from ruboty.

Put the command into commands/ directory where your
bot lives in. The command's path name is used as is handler.
When you say '@bot: example hello', ruboty runs the command
$PWD/commands/example/hello or $RUBOTY_ROOT/commands/example/hello
if RUBOTY_ROOT is defined.

All of commands under `commands/` directory are executed with `-h`
option once to gather their usage information used for help message
of ruboty. Please implement `-h` option into the commands.

## Command Controll

List running commands:

    > ruboty command list

Kill running command, you can specify command index in the result of ```command list``` or PID

    > ruboty command kill <index|PID>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-exec_command'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruboty-exec_command

## Environment Variables

| Name                     | Description                  | Default           |
|--------------------------|------------------------------|-------------------|
| LOG_LEVEL                | log level                    | 1 (Logger::INFO)  |
| EXEC_COMMAND_OUTPUT_ROOT | The command output root      | logs/exec_command |
| EXEC_COMMAND_OUTPUT_DIR  | The command output directory | "#{root}/%Y-%m    |

## History

- 0.1.3:
 - fix: output_file_names time stamp jitter

- 0.1.2:
 - fix: not to match with shorter name commands
 - add: symlink to output files to tail -F easily
 - add: Bundler.with_clean_env to run a ruby script with bundler inside ruboty
 - add: logging to see what's going on with ruboty 

- 0.1.1:
 - each message contains PID

- 0.1.0:
 - command runs as a back ground thread
 - command accepts option arguments

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ruboty-exec_command/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
