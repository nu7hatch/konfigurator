$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "rubygems"
require "test/unit"
require "contest"

require "konfigurator/simple"
require "konfigurator/dsl"
