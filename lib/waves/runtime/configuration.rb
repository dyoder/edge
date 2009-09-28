module Waves

  module Configurations

    class Base
      # Set the given attribute with the given value. Typically, you wouldn't
      # use this directly.
      def self.[]=( name, val )
        meta_def("_#{name}") { val }
      end

      # Get the value of the given attribute. Typically, you wouldn't
      # use this directly.
      def self.[]( name ) ; send "_#{name}" rescue nil ; end

      # Define a new attribute. After calling this, you can get and set the value
      # using the attribute name as the method
      def self.attribute( name )
        meta_def(name) do |*args|
          raise ArgumentError.new('Too many arguments.') if args.length > 1
          args.length == 1 ? self[ name ] = args.first : self[ name ]
        end
        self[ name ] = nil
      end

      def self.attributes( *names )
        names.each { |name| attribute( name ) }
      end

    end

    # The Default configuration defines sensible defaults for attributes required by Waves.
    class Default < Base

      # define where a server should listen
      # can be overridden by -p and -h options
      attributes( :host, :port, :ports )

      # which server to use, ex: Waves::Servers::Mongrel
      attribute( :server )

      # where will the logger write to? can be a IO object or a pathname
      # also can set the level here to :fatal, :debug, :warn, :info
      attribute( :log )

      # which modules are going to be reloaded on each request?
      attribute( :reloadable )

      # which resource to use as the "main" resource for this server
      attribute( :resource )

      # parameters for the database connection, varies by ORM
      attribute( :database )

      # set the debug mode flag; typically done in dev / test configurations
      attribute( :debug )

      # what object to use as the main Waves cache
      attribute( :cache )

      # do you want to run a console thread (ex: LiveConsole)
      attribute( :console )
      
      # what dispatcher do you want to use
      attribute( :dispatcher )

      # are there any gems we need to check for on startup?
      def self.dependencies( list )
        list.each do |d| 
          gem d[:name], d[:version]
          require d[:load] if d[:load]
        end
      end

      # Provides access to the Waves::MimeTypes class via the configuration. You
      # can override #mime_types to return your own MIME types repository class.
      def self.mime_types
        Waves::MimeTypes
      end

      # Defines the application for use with Rack.  Treat this method like an
      # instance of Rack::Builder
      def self.application( &block )
        if block_given?
          self['application'] = Rack::Builder.new( &block )
        else
          self['application'] ||= Rack::Builder.new
        end
      end
      
      def self.use( middleware, options )
        application.use( middleware, options )
      end
      
      # default options
      debug false
      log :level => :info, :output => $stderr
      reloadable []
      dependencies []
      server Waves::Servers::WEBrick
      application.use ::Rack::ShowExceptions
      dispatcher Waves::Dispatchers::Default

    end
  end
end
