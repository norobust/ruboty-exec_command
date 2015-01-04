require "spec_helper"

describe Ruboty::ExecCommand::CommandSlot do

  before do
    @slot = Ruboty::ExecCommand::CommandSlot.new
    @command = Ruboty::ExecCommand::Command.new(command_args: "example sleep")
  end

  describe "#run" do
    it "should count up number of commands" do
      expect { @slot.run(@command) }.to change {
          @slot.running_commands.count
        }.from(0).to(1)
    end

    it "should return pid" do
      expect(@slot.run(@command)).to be > 0
    end
  end
end


describe Ruboty::ExecCommand::CommandSlot do

  before(:each) do
    @slot = Ruboty::ExecCommand::CommandSlot.new
    @command = Ruboty::ExecCommand::Command.new(command_args: "example sleep")
    @slot.remember(@command)
    @command.run_bg(["1"])
  end

  describe "#forget" do
    it "should count down number of commnads" do
      expect { @command.pid }.not_to be_nil
      expect { @slot.forget(@command.pid) }.to change {@slot.running_commands.count}.from(1).to(0)
    end
  end

  describe "#command_in_list" do
    it "should return command with pid" do
      expect(@slot.command_in_list(@command.pid).pid).to eq(@command.pid)
    end

    it "should return command with index" do
      expect(@slot.command_in_list(1).pid).to eq(@command.pid)
    end
  end

end
