module Ruboty
  module ExecCommand
    module Actions
      class Command < Ruboty::Actions::Base
        def call
          # TODO: add timeout
          c = Ruboty::ExecCommand::Command.new(command_args: command_body)
          run_and_monitor(c)
        end

        def command_slot
          message.robot.brain.data[:command_slot] ||= Ruboty::ExecCommand::CommandSlot.new
        end

        def list_commands
          message.reply(command_slot.list_commands)
        end

        def kill_command
          # TODO: command list lock
          # kill running process, command is "kill command <index>"
          if command_slot.kill(message.body.split.last.to_i).nil?
            message.reply("Command [#{message.body.split.last}] not found.")
          end
        end

        def run_and_monitor(comm)
          pid = command_slot.run(comm)
          msg = "[#{comm.command_name}] invoked. PID: #{comm.pid}"
          Ruboty.logger.info { "[EXEC_COMMAND] #{msg}" }
          message.reply(msg)

          # Waiter thread
          thread = Thread.new do
            ignore_pid, status = Process.wait2(pid)
            command_slot.forget(pid)

            if status.exitstatus == 0
              msg = "[#{comm.command_name}] completed successfully. PID: #{comm.pid}"
              Ruboty.logger.info { "[EXEC_COMMAND] #{msg}" }
              message.reply(msg)
              message.reply(comm.stdout_log.chomp)
            elsif status.signaled?
              msg = "[#{comm.command_name}] killed by signal #{status.termsig} PID: #{comm.pid}"
              Ruboty.logger.info { "[EXEC_COMMAND] #{msg}" }
              message.reply(msg)
            else
              msg = "[#{comm.command_name}] exit status with #{status} PID: #{comm.pid}\n" +
                comm.stdout_log + "stderr: " + comm.stderr_log.chomp
              Ruboty.logger.info { "[EXEC_COMMAND] #{msg}" }
              message.reply(msg)
            end
          end

          if ENV['RUBOTY_ENV'] == 'blocked_test'
            thread.join
          end
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
