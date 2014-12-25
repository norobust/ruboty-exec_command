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
        @command_args = args[:command_args]
      end

      def absolute_path
        @absolute_path ||= command2path
      end

      def relative_path
        @relative_path ||= absolute_path.sub(/^#{self.class.command_root}\//,"")
      end

      def command_args
        @command_args ||= relative_path.gsub('/', ' ')
      end

      def command2path
        path = self.class.command_root
        @command_args.split(" ").each do |arg|
          path = "#{path}/#{arg}"
          return path if self.class.command?(path)
        end
        ""
      end

      def run(args=[])
        `#{absolute_path} #{args.join(" ")}`
      end

      def help
        run(args=['-h'])
      end

    end
  end
end
