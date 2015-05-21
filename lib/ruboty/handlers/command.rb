require "ruboty/exec_command/actions/command"

module Ruboty
  module Handlers
    class Command < Base

      on(/command list/i, name: "list_commands",
          description: "List running commands in background")

      on(/command kill/i, name: "kill_command",
          description: "command kill <index|PID>  ")

      # Registering commands. Each command is located
      # under "commands" directory. The path name to the
      # executable command is gonna be a command name.
      #  i.e. commands/server/monitor => /server monitor/
      # All of commands are called with -h option on the startup.
      # The command should return a usage with -h option
      def self.register_commands
        Ruboty::ExecCommand::Command.all.each do |e|
          on /#{e.command_name}/i, name: "command_handler", description: e.help
        end
      end

      def command_handler(message)
        Ruboty::ExecCommand::Actions::Command.new(message).call
      end

      def list_commands(message)
        Ruboty::ExecCommand::Actions::Command.new(message).list_commands
      end

      def kill_command(message)
        Ruboty::ExecCommand::Actions::Command.new(message).kill_command
      end
    end
  end
end

Ruboty::Handlers::Command.register_commands
