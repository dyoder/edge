require 'yaml'

require "rubygems"
YAML::load_file( File.expand_path( File.dirname( __FILE__ )) + '/../dependencies.yml' ).each { |name,version| gem name, version }

# External Dependencies
require 'rack'
require 'rack/cache'
require 'daemons'

# a bunch of handy stuff
require 'extensions/io'
require 'extensions/symbol' unless Symbol.instance_methods.include? 'to_proc'
require 'fileutils'
require 'metaid'
require 'forwardable'
require 'date'
require 'benchmark'
require 'base64'
require 'functor'
require 'filebase'
require 'hive/worker'
require 'filebase/model'

# selected project-specific extensions
require 'waves/ext/integer'
require 'waves/ext/float'
require 'waves/ext/string'
require 'waves/ext/symbol'
require 'waves/ext/hash'
require 'waves/ext/tempfile'
require 'waves/ext/module'
require 'waves/ext/object'
require 'waves/ext/kernel'
require 'waves/ext/time'

# waves Runtime
require 'waves/servers/base'
require 'waves/servers/webrick'
require 'waves/servers/mongrel'
require 'waves/request/accept'
require 'waves/request/request'
require 'waves/response/response'
require 'waves/response/packaged'
require 'waves/response/client_errors'
require 'waves/response/response_mixin'
require 'waves/response/redirects'
require 'waves/dispatchers/base'
require 'waves/dispatchers/default'
require 'waves/runtime/logger'
require 'waves/media/mime_types'
require 'waves/runtime/applications'
require 'waves/runtime/runtime'
require 'waves/runtime/configuration'
require 'waves/caches/simple'

# waves URI mapping
require 'waves/matchers/accept'
require "waves/matchers/ext"
require 'waves/matchers/path'
require 'waves/matchers/query'
require 'waves/matchers/traits'
require 'waves/matchers/uri'
require 'waves/matchers/request'
require 'waves/matchers/resource'
require 'waves/matchers/requested'
require 'waves/resources/paths'
require 'waves/resources/mixin'

require 'waves/views/mixin'
require 'waves/views/errors'
require 'waves/renderers/mixin'

module Waves
  def self.version ; File.read( File.expand_path( "#{File.dirname(__FILE__)}/../doc/VERSION" ) ) ; end
  def self.license ; File.read( File.expand_path( "#{File.dirname(__FILE__)}/../doc/LICENSE" ) ) ; end
end