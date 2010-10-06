$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "rubygems"
require "test/unit"
require "contest"
require "fileutils"
require "konfigurator"

COMMON_TESTS = <<-EVAL
  should "respond to #environment and #env" do 
    assert subject.respond_to?(:environment)
    assert subject.respond_to?(:env)
  end
  
  should "respond to #settings and #config" do 
    assert subject.respond_to?(:settings)
    assert subject.respond_to?(:config)
  end
  
  should "respond to #configure" do 
    assert subject.respond_to?(:configure)
  end
EVAL

CONFIG_FILE_CONTENT = <<-CONTENT
production:
  foo: bar
  bla: true
development: 
  foo: bla
  bla: false
CONTENT

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
