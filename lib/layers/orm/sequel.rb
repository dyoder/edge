require 'sequel'
require File.dirname(__FILE__) / :sequel / :tasks / :schema if defined?(Rake)
require File.dirname(__FILE__) / :sequel / 'model'

module Waves
  module Layers
    module ORM
      
      module Sequel

        def self.included(app)
          app.instance_eval do
            
            autoinit :Models do
              autocreate_class true, Waves::Layers::ORM::Model do
                set_dataset app.database[ basename.snake_case.plural.intern]
              end
              autoload_class true, Waves::Layers::ORM::Model
        	  end
        	  
            meta_def( :database ) { @sequel ||= ::Sequel.open( config.database ) }
            
          end
        end

      end
    end
  end
end

