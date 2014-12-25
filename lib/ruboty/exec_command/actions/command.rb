module Ruboty
  module ExecCommand
    module Actions
      class Command < Ruboty::Actions::Base
        def call
          # TODO: add timeout
          extension = Ruboty::ExecCommand::Command.new(command_args: command_body)
          message.reply(extension.run.chomp)
        end

        def robot_prefix_pattern
          Ruboty::Action.prefix_pattern(message.original[:robot].name)
        end

        def command_body
          message.body.sub(robot_prefix_pattern,'')
        end
      end
    end
  end
end
