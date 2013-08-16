require 'spec_helper'
require 'puppet_worker'

describe MaestroDev::Plugin::PuppetWorker do

  let(:workitem) { {'fields' => fields} }
  let(:fields) { {} }

  before { subject.workitem = workitem }

  context 'when invoking runonce' do
    let(:identity_filter) { 'pe-client.maestrodev.net' }
    let(:verbose) { true }
    let(:fields) { {
      'identity_filter' => identity_filter,
      'verbose' => verbose
    } }

    it "should succeed" do
      rpcclient = double('rpcclient')
      subject.stub(:client => rpcclient)
      rpcclient.should_receive(:verbose=).with(verbose)
      rpcclient.should_receive(:progress=).with(false)
      rpcclient.should_receive(:identity_filter).with(identity_filter)

      stats = double("stats", :report => '')

      rpcclient.stub(:stats => stats)
      rpcclient.should_receive(:runonce).and_return([])
      # Don't disconnect. We end up with a stale/disconnected connection and can't send messages to the stomp
      # server anymore.
      rpcclient.should_not_receive(:disconnect)
      subject.should_receive(:write_output).at_least(:twice)

      subject.runonce

      subject.error.should be_nil
    end
  end

  context "when validating fields" do
    before { subject.validate_fields }
    it 'should send an error if required fields are missing' do
      subject.error.should == 'Missing Fields: verbose,identity_filter'
    end
  end

end
