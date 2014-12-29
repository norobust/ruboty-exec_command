module Ruboty
  module ExecCommand
    class Command

      class << self
        def command_root
          "#{ENV['RUBOTY_ROOT'] || Dir.pwd}/commands"
        end

        def command?(path)
          File.executable?(path) and not File.directory?(path)
        end

        def files
          Dir[command_root+'/**/*'].select do |path|
            command?(path)
          end
        end

        def all
          files.map do |e|
            Command.new(absolute_path: e)
          end
        end
      end

      def initialize(args={})
        args = { absolute_path: nil, command_args: nil }.merge(args)
        @absolute_path = args[:absolute_path]
        @command_args = args[:command_args].split if not args[:command_args].nil?
      end

      def absolute_path
        @absolute_path ||= command2path[0]
      end

      def relative_path
        @relative_path ||= absolute_path.sub(/^#{self.class.command_root}\//,"")
      end

      def command_args
        @command_args ||= relative_path.split('/')
      end

      def __command2path(path, args)
        return ["", ""] if args == []

        if self.class.command?(path)
          [path, args]
        else
          __command2path("#{path}/#{args[0]}", args.slice(1, args.length))
        end
      end

      def command2path
        path = self.class.command_root
        __command2path "#{path}/#{@command_args[0]}",
                      @command_args.slice(1, @command_args.length)
      end

      def opt_args
        @opt_args ||= command2path[1]
      end

      def run(args=[])
        `#{absolute_path} #{args.join(" ")}`
      end

      def help
        run(args=['-h']).chomp
      end

    end
  end
end
