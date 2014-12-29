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

  let(:replied) do
    "hello world!"
  end

  before do
    ENV['RUBOTY_ROOT'] = Dir.pwd
  end

  describe "#command_handler" do
    it "run example command" do
      robot.should_receive(:say).with(
      body: replied,
      from: to,
      to: from,
      original: {
        body: said,
        from: from,
        robot: robot,
        to: to,
      },
      )
      robot.receive(body: said, from: from, to: to)
    end
  end

end
