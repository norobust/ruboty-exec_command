module Ruboty
  module ExecCommand
    class CommandSlot

      def initialize
        @commands = []
      end

      def running_commands
        @commands
      end

      def remember(comm)
        # remember
        #     comm: command object
        # TODO: add owner info
        @commands << comm
      end

      def forget(pid)
        # remove thread object
        @commands.delete_if do |c|
          c.pid == pid
        end
      end

      def command_in_list(idx_or_pid)
        found = @commands.index { |c| c.pid == idx_or_pid }

        if found.nil?
          i = idx_or_pid.to_i
          num_commands = @commands.size
          if i <= 0 or i > num_commands
            nil
          else
            @commands[i-1]
          end
        else
          @commands[found]
        end
      end

      def run(command)
        remember(command)
        command.run_bg(command.opt_args)
      end

      def list_commands
        if @commands.size == 0
          "No command running."
        else
          number = 0
          @commands.map do |c|
            number += 1
            "#{number}: #{c.command_name} (PID[#{c.pid}], started at #{c.start_at})\n"
          end.join.chomp
        end
      end

      def kill(idx_or_pid)
        command = command_in_list(idx_or_pid)
        unless command.nil?
          Process.kill(-9, command.pid) # kill process group
          forget(command.pid)
        end
        command
      end
    end
  end
end
