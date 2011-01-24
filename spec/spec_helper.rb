$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "rspec"
require "mocha"
require "fileutils"
require "konfigurator"

RSpec.configure do |conf|
  conf.mock_with :mocha
end

CONFIG_FILE_CONTENT = <<-YAML
production:
  foo: bar
  bla: true
development: 
  foo: bla
  bla: false
YAML

shared_examples_for "configured" do
  it "responds to #environment and #env" do 
    subject.should respond_to(:environment)
    subject.should respond_to(:env)
  end
  
  it "responds to #settings and #config" do 
    subject.should respond_to(:settings)
    subject.should respond_to(:config)
  end
  
  it "responds to #configure" do 
    subject.should respond_to(:configure)
  end
end

class ConfiguredWithSimple
  include Konfigurator::Simple
end

class ConfiguredWithDSL
  include Konfigurator::DSL
  attr_config :foo, :bar
end

def with_conf_file(&block)
  fname = File.join(File.dirname(__FILE__), 'conf.yml')
  File.open(fname, "w+") {|f| f.write(CONFIG_FILE_CONTENT) }
  yield fname
  FileUtils.rm(fname)
end
