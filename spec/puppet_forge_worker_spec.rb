require 'spec_helper'
require 'puppet_forge_worker'

describe MaestroDev::Plugin::PuppetForgeWorker do

  let(:workitem) { {'fields' => fields} }
  let(:path) { File.dirname(__FILE__) + '/data' }
  let(:fields) { {
    'forge_username' => 'maestrodev',
    'forge_password' => 'mypassword',
    'name' => 'maven',
    'path' => path
  } }
  let(:package) { File.expand_path(File.join(File.dirname(__FILE__), 'data/pkg', 'maestrodev-test-1.0.0.tar.gz')) }

  before { subject.workitem = workitem }

  context "when pushing to the forge" do
    before do
      subject.stub(:last_commit_was_automated? => false)
      Blacksmith::Forge.any_instance.should_receive(:push!).with('test', package)
      Blacksmith::Modulefile.any_instance.should_receive(:bump!)
      Blacksmith::Git.any_instance.should_receive(:tag!)
      Blacksmith::Git.any_instance.should_receive(:commit_modulefile!)
      Blacksmith::Git.any_instance.should_receive(:push!)
      subject.forge_push
    end
    it { subject.forge.username.should eq('maestrodev') }
    it { subject.forge.password.should eq('mypassword') }
    it { subject.forge.url.should eq('https://forgeapi.puppetlabs.com') }
  end

  context "when fields are missing" do
    let(:fields) {{}}
    before { subject.stub(:last_commit_was_automated? => false)}
    it "should fail" do
      expect { subject.forge_push }.to raise_error(MaestroDev::Plugin::ConfigError, /^Configuration errors/)
    end
  end

end
