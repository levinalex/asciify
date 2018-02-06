#!/usr/bin/ruby

require 'iconv'
require 'enumerator'
require 'yaml'


class Asciify
  Intermediate = "UCS-4"
  PackFormat = "N*"

  def self.mapping_config
    @mapping_config
  end

  def self.mapping_config=(input)
    @mapping_config = input
    @default_mapping = Asciify::Mapping.new(*input)
  end

  def self.default_mapping
    @default_mapping
  end

  class Mapping
    class << self
      alias_method :[], :new
    end
    
    # converts an UTF-8 string to an array of unicode codepoints
    #
    def from_utf8(str)
      Iconv.new(Intermediate,"UTF-8").iconv(str).unpack(PackFormat)
    end
    
    # define a mapping from Unicode codepoints to ASCII chars
    # +language+ can be a path to a yaml file which contains the
    # mappings as a Hash
    #
    # If +language+ is a symbol, it refers to a builtin mapping
    #
    def initialize(language = :default, replacement = "?")
      if Symbol === language
        path = "#{File.dirname(__FILE__)}/mappings/#{language}.yaml"
      else
        path = language
      end
      
      h = YAML.load_file(path)
      i = Iconv.new("UCS-4","UTF-8")
      
      # use the default replacement if the hash 
      @map = Hash.new( i.iconv(replacement).unpack(PackFormat) )
        
      # the mappings file is UTF-8, recode to UCS-4
      h.each { |k,v|
        @map[*i.iconv(k).unpack(PackFormat)] = i.iconv(v).unpack(PackFormat)
      }
      
      @map
    end

    def [](codepoint)
      @map[codepoint]
    end
    
  end

  class HTMLEntities < Mapping
    
    # mapping from Unicode codepoints to numeric HTML entities
    #
    #   Asciify.new(Asciify::HTMLEntities).convert("\303\244") #=> "&#228;"
    #
    def [](codepoint)
      from_utf8 "&##{codepoint};"
    end
  end
  
  def initialize(replacement = nil, target = "ASCII", source = "UTF-8")
    @from_input_enc = Iconv.new(Intermediate, source)
    @to_output_enc = Iconv.new(target, Intermediate)
    replacement ||= self.class.default_mapping

    if replacement.is_a?(Asciify::Mapping)
      @mapping = replacement
    elsif replacement.is_a?(Symbol)
      @mapping = Asciify::Mapping.new(replacement)
    elsif !replacement
      replacement = '?'
    end

    # By this point we've pretty much ensured either it's a string or the mapping is already set.
    @mapping ||= Hash.new(@from_input_enc.iconv(replacement).unpack(PackFormat))
  end

  def convert(str)
    u16s = @from_input_enc.iconv(str)
  
    s = u16s.unpack(PackFormat).collect { |codepoint|
      codepoint < 128 ? codepoint : @mapping[codepoint]
    }.flatten.compact.pack(PackFormat)
  
    return @to_output_enc.iconv(s)
  end

end

class String
  
  # removes all characters which are not part of ascii
  # and replaces them with +replacement+
  #
  # +replacement+ is supposed to be the same encoding as +source+
  #
  def asciify(*args)
    Asciify.new(*args).convert(self)
  end

  def ascii?
    self.to_enum(:each_byte).all? { |b| b < 128 }
  end
end

if __FILE__ == $0
end

