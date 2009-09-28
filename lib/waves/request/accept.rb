module Waves
  class Accept < Array

    #
    # RFC 2616 section 14.1.
    #
    # Returns an array of elements of the form:
    #
    # [ term, params ]
    #
    # where is term is an array of MIME type components,
    # with the true value as the wildcard (*)
    #
    # and where params is a hash of parameters (q, level, etc.),
    # where the q param is auto-converted to a float and 
    # defaulted to 1.0.
    #
    # sorted by q value and then specificity, with ties going
    # to HTML-related media-types
    #
    #
    # TODO  parsing must be optimized. This parses Accept,
    #       lang and charset
    #
    def Accept.parse(str)
      return self.new if str.nil?
      self.new( Accept.sort( str.split(',').map { |term| Accept.parse_media_type( term ) } ).uniq )
    end
  
    def Accept.parse_media_type( term )
      t, *p = term.to_s.split(';').map(&:strip) 
      [ Accept.parse_media_range( t ), Accept.convert_params_to_hash( p ) ]
    end
  
    def Accept.parse_media_range( t )
      t.split('/').map(&:strip).map { |x| x=='*' ? true : x }
    end
  
    def Accept.convert_params_to_hash( p )
      rval = p.inject({}) { |h,p|
        k,v = p.split('=').map(&:strip)
        ( v = v.to_f ) if k == 'q'
        h[k] = v ; h
      }
      rval['q'] ||= 1.0
      rval
    end
  
    def Accept.sort( terms )
      terms.sort { |t1,t2| 
        # first compare on quality
        c = t2[1]['q'] <=> t1[1]['q']
        # next compare on specificity of the media type
        c = t2[0].size <=> t1[0].size if ( c == 0 )
        # finally, compare on specificity of parameters
        c = t2[1].size <=> t1[1].size if ( c == 0 )
        c
      }
    end
  
    def Accept.to_media_type( term )
      term.first.map { |x| x==true ? '*' : x }.join("/")
    end

    def =~(arg) ; self.include? arg ; end
    def ===(arg) ; self.include? arg ; end

    # Check these Accepts against constraints.
    #
    def include?(arg)
      # recursively test for any possibility if we get an array
      # thus you can match against, say, %w( png jpg gif )
      return arg.any? {|pat| self.include? pat } if arg.kind_of? Array
      term = Accept.parse_media_type( arg ).first
      self.map(&:first).any? { | type, subtype |
        case term
        when [ type ], [ subtype ], [ true ],
            [ type, subtype ], [ type, true ], 
            [ true, true ] then true
        else false
        end
      }
    end

    # Again, we play favorites here: in the absence of any accept header
    # we go with 'text/html' as our favorite
    def preferred_media_type
      Accept.to_media_type( first ) || 'text/html'
    end

  end
end