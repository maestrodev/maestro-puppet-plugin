require 'spec_helper'

describe MaestroDev::PuppetWorker do

  before :each do
    @test_participant = MaestroDev::PuppetWorker.new
  end

  it "should echo a message" do
    wi = Ruote::Workitem.new({'fields' => {
                              'agent' => 'vm-agent-01.example.com',
                              }})

    # @test_participant.expects(:workitem => wi.to_h).at_least_once

    # # TODO: try using mcollective-test to try it out
    # @test_participant.runonce

    # @test_participant.error.should be_nil
    # @test_participant.workitem['__output__'].should match /Hello, World/
  end
end
