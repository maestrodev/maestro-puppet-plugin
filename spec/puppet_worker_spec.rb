require 'spec_helper'

describe MaestroDev::PuppetWorker do

  before :each do
    @worker = MaestroDev::PuppetWorker.new
    @worker.stub(:write_output)
  end

  it 'should invoke runonce' do
    identity_filter = 'pe-client.maestrodev.net'
    verbose = true
    wi = Ruote::Workitem.new({'fields' => {
                              'identity_filter' => identity_filter,
                              'verbose' => verbose
                              }})
    @worker.stub(:workitem => wi.to_h)
    rpcclient = double('rpcclient')
    @worker.stub(:client => rpcclient)
    rpcclient.should_receive(:verbose=).with(verbose)
    rpcclient.should_receive(:progress=).with(false)
    rpcclient.should_receive(:identity_filter).with(identity_filter)

    stats = double("stats", :report => '')

    rpcclient.stub(:stats => stats)
    rpcclient.should_receive(:runonce).and_return([])
   # rpcclient.should_receive(:disconnect)
    @worker.should_receive(:write_output).at_least(:twice)

    @worker.runonce

    @worker.error.should be_nil

  end

  it 'should send an error if required fields are missing' do
    wi = Ruote::Workitem.new({'fields' => { } })
    @worker.stub(:workitem => wi.to_h)
    @worker.validate_fields
    @worker.error.should == 'Missing Fields: verbose,identity_filter'
  end


end
