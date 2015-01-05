require "spec_helper"

describe Ruboty::Handlers::Command do

  let(:robot) do
    Ruboty::Robot.new
  end

  let(:from) do
    "alice"
  end

  let(:to) do
    "#general"
  end

  let(:said) do
    "@ruboty example hello world"
  end

  let(:said_to_sleep) do
    "@ruboty example sleep 5"
  end

  let(:said_to_kill) do
    "@ruboty command kill 1"
  end

  let(:said_to_list) do
    "@ruboty command list"
  end

  let(:replied) do
    /\[example hello\] invoked. PID: \d+/
  end

  let(:replied_sleep) do
    /\[example sleep\] invoked. PID: \d+/
  end

  let(:replied_success) do
    /\[example hello\] completed successfully. PID: \d+/
  end

  let(:replied_stdout) do
    "hello world!"
  end

  let(:replied_after_kill) do
    /\[example sleep\] killed by signal 9 PID: \d+/
  end

  def reply_data(body, original_body)
    {
      body: body,
      from: to,
      to: from,
      original: {
        body: original_body,
        from: from,
        robot: robot,
        to: to,
      }
    }
  end


  def should_receive_body(reply)
    robot.should_receive(:say) do |args, options|
      args[:body].should match(reply)
    end
  end

  before do
    ENV['RUBOTY_ROOT'] = Dir.pwd
  end

  describe "#command_handler" do
    before do
      # block waiter thread in Ruboty::ExecCommand::Actions::Command.run_and_monitor
      ENV['RUBOTY_ENV'] = "blocked_test"
    end

    it "run example command" do
      #robot.should_receive(:say).with(reply_data(replied, said))
      should_receive_body(replied)
      should_receive_body(replied_success)
      robot.should_receive(:say).with(reply_data(replied_stdout, said))
      robot.receive(body: said, from: from, to: to)
    end

    after do
      ENV['RUBOTY_ENV'] = "test"
    end
  end

  describe "#kill_command" do
    it "run kill command" do
      thread = Thread.new do
        ENV['RUBOTY_ENV'] = "blocked_test"
        should_receive_body(replied_sleep)
        should_receive_body(replied_after_kill)
        robot.receive(body: said_to_sleep, from: from, to: to)
      end


      # Test command invoked
      expect { robot.receive(body: said_to_kill, from: from, to: to) }.to change {
        robot.brain.data[:command_slot].running_commands.count}.from(1).to(0)

        # Wait killed message
      thread.join
    end

    after do
      ENV['RUBOTY_ENV'] = "test"
    end
  end

  describe "#list_command" do
    it "list running commands" do
      robot.receive(body: said_to_sleep, from: from, to: to)
      robot.receive(body: said_to_sleep, from: from, to: to)

      comm1 = robot.brain.data[:command_slot].running_commands[0]
      comm2 = robot.brain.data[:command_slot].running_commands[1]
      body1="1: example sleep (PID[#{comm1.pid}], started at #{comm1.start_at})\n"
      body2="2: example sleep (PID[#{comm2.pid}], started at #{comm2.start_at})"

      robot.should_receive(:say).with(reply_data(body1+body2, said_to_list))
      robot.receive(body: said_to_list, from: from, to: to)
    end

    after do
      ENV['RUBOTY_ENV'] = "test"
    end
  end

end
