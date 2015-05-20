require 'fileutils'

module Ruboty
  module ExecCommand
    class Command

      class << self
        def ruboty_root
          "#{ENV['RUBOTY_ROOT'] || Dir.pwd}"
        end

        def command_root
          "#{ruboty_root}/commands"
        end

        def output_root
          ENV['EXEC_COMMAND_OUTPUT_ROOT'] || "#{ruboty_root}/logs/exec_command"
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
        @pid = nil
        @start_at = nil
      end

      attr_reader :pid
      attr_reader :start_at

      def absolute_path
        @absolute_path ||= command2path[0]
      end

      def relative_path
        @relative_path ||= absolute_path.sub(/^#{self.class.command_root}\//,"")
      end

      def command_name
        @command_name ||= relative_path.gsub('/', ' ')
      end

      def __command2path(path, args)
        if self.class.command?(path)
          [path, args]
        else
          if args == []
            # command not found
            return ["", ""]
          else
            __command2path("#{path}/#{args[0]}", args.slice(1, args.length))
          end
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

      def this_month
        Time.now.strftime "%Y-%m"
      end

      def this_time
        Time.now.strftime "%Y-%m-%d_%H:%M:%S"
      end

      def output_dir
        d = ENV['EXEC_COMMAND_OUTPUT_DIR'] || "#{self.class.output_root}/#{this_month}"
        FileUtils.mkdir_p(d) if not Dir.exists?(d)
        d
      end

      # symlink to output_file_name so that we can easily tail -F
      def symlink_file_name
        %Q(#{output_dir}/#{command_name.gsub(" ", "_")})
      end

      def output_file_name
        %Q(#{output_dir}/#{command_name.gsub(" ", "_")}-#{this_time})
      end

      # return symlink output file name [stdout, stderr]
      def symlink_files
        ["#{symlink_file_name}.out", "#{symlink_file_name}.err"]
      end

      # return temporary output file name [stdout, stderr]
      def output_files
        ["#{output_file_name}.out", "#{output_file_name}.err"]
      end

      # return contents of stdout
      def stdout_log
        File.open(output_files[0]).read
      end

      # return contents of stderr
      def stderr_log
        File.open(output_files[1]).read
      end

      def run(args=[])
        `#{absolute_path} #{args.join(" ")}`
      end

      def run_bg(args=[])
        stdout, stderr = output_files
        @start_at = this_time
        stdout_link, stderr_link = symlink_files
        FileUtils.ln_sf(stdout, stdout_link)
        FileUtils.ln_sf(stderr, stderr_link)
        cmd = %Q(#{absolute_path} #{args.join(" ")})
        with_clean_env do
          @pid = Process.spawn(cmd, pgroup: true, out: stdout, err: stderr)
        end
        Ruboty.logger.debug { "[EXEC_COMMAND] Invoked `#{cmd}`. PID: #{@pid}" }
        @pid
      end

      def help
        run(args=['-h']).chomp
      end

      def with_clean_env(&block)
        if defined?(Bundler)
          Bundler.with_clean_env do
            yield
          end
        else
          yield
        end
      end
    end
  end
end
