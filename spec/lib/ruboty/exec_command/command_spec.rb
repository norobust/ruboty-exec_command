require "spec_helper"

# Specs for class methods
describe Ruboty::ExecCommand::Command do
  describe "#all" do
    let(:all_commands) do
      Ruboty::ExecCommand::Command.all
    end

    it "should return an array" do
      expect(all_commands).to be_a(Array)
    end

    it "should return an array of Extension objects" do
      all_commands.each do |e|
        expect(e).to be_an_instance_of(Ruboty::ExecCommand::Command)
      end
    end

    it "should contain absolute path" do
      all_commands.each do |e|
        expect(e.absolute_path).to_not eq("")
      end
    end
  end
end

# Specs for instance methods
describe Ruboty::ExecCommand::Command do
  before do
    ENV['RUBOTY_ROOT'] = "/xxx"
    @e = Ruboty::ExecCommand::Command.new(absolute_path: "/xxx/commands/a/b")
  end

  describe "#command" do
    it "should return command name" do
      expect(@e.command_name).to eq("a b")
    end
  end
end

# convert command args -> absolute path, so this is a test for ruboty action
describe Ruboty::ExecCommand::Command do
  before(:each) do
    ENV['RUBOTY_ROOT'] = Dir.pwd
    @c = Ruboty::ExecCommand::Command.new(command_args: "example hello hoge -l fuga")
  end

  describe "#absolute_path" do
    it "should return absolute path" do
      expect(@c.absolute_path).to eq("#{ENV['RUBOTY_ROOT']}/commands/example/hello")
    end
  end

  describe "#opt_args" do
    it "should return only command options" do
      expect(@c.opt_args).to eq(["hoge", "-l", "fuga"])
    end
  end
end
