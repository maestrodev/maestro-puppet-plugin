require 'spec_helper'
require 'puppet_worker'

describe MaestroDev::Plugin::PuppetWorker do

  let(:workitem) { {'fields' => fields} }
  let(:fields) { {} }

  before(:each) do
    Maestro::MaestroWorker.mock!
  end

  context 'when invoking runonce' do
    let(:identity_filter) { 'pe-client.maestrodev.net' }
    let(:verbose) { true }
    let(:fields) { {
      'identity_filter' => identity_filter,
      'verbose' => verbose
    } }

    it 'should detect missing params' do
      workitem = {'fields' => {}}
      subject.perform(:runonce, workitem)
      workitem['fields']['__error__'].should include('missing field identity_filter')
    end

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

      subject.perform(:runonce, workitem)

      subject.error.should be_nil
    end
  end

end
