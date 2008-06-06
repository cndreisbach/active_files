# Equivalent to a header guard in C/C++
# Used to prevent the class/module from being loaded more than once
unless defined? ActiveFiles

  require File.dirname(__FILE__) + '/lib_helper'
  require 'fileutils'
  require 'yaml'

  module ActiveFiles

    # :stopdoc:
    VERSION = '0.1.0'
    LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
    PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
    # :startdoc:

    extend LibHelper

    @@base_dir = nil
    @@ext = '.yaml'

    # This should definitely be used right off the bat, like so:
    #
    # <tt>ActiveFiles.base_dir = '/dir/where/I/store/files'</tt>
    #
    # This is where all your ActiveFiles files will be loaded from
    # and saved to.
    def self.base_dir=(dir)
      FileUtils.mkdir_p dir
      @@base_dir = dir
    end

    # Accessor! Find out your ActiveFiles directory.
    def self.base_dir
      @@base_dir
    end

    # Probably never used, but you can change the default
    # ActiveFiles extension, which is ".yaml".
    def self.ext=(ext)
      @@ext = ext
    end

    # Accessor! Get your ActiveFiles file extension.
    def self.ext
      @@ext
    end
    
  end  # module ActiveFiles

  ActiveFiles.require_all_libs_relative_to __FILE__

end  # unless defined?

