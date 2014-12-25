require "ruboty/exec_command/actions/command"

module Ruboty
  module Handlers
    class Command < Base
      # Registering commands. Each command is located
      # under "commands" directory. The path name to the
      # executable command is gonna be a command name.
      #  i.e. commands/server/monitor => /^server monitor.*/
      # The command should return a usage with -h option
      def self.register_commands
        Ruboty::ExecCommand::Command.all.each do |e|
          on /#{e.command_args}/i, name: "command_handler", description: e.help
        end
      end

      def command_handler(message)
        Ruboty::ExecCommand::Actions::Command.new(message).call
      end
    end
  end
end

Ruboty::Handlers::Command.register_commands
