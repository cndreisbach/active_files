active_files
============

by Clinton R. Nixon

http://github.com/crnixon/active_files

## Description

This library attempts to implement an ActiveRecord-like interface to
a directory structure of flat files containing serialized objects,
probably in YAML.

## Features/problems

* Serializes any object
* No validations yet

## Requirements

To run tests, you need the spect and Shoulda gems.

## Synopsis

    ActiveFiles.base_dir = '/tmp/af'

    class Person < Hash
      include ActiveFiles::Record
      add_file_id_to_initialize
    end

    class Wingdom
      include ActiveFiles::Record

      attr_reader :feathers, :color
  
      def initialize(id, feathers, color)
        self.file_id = id
        @feathers = feathers
        @color = color
      end

      def to_activefile
        { :plumoj => @feathers.to_s.split(//).reverse,
          :koloro => [@color, @color, @color].join('\/') }.to_yaml.reverse
      end

      def self.from_activefile(yaml, file_id)
        hash = YAML::load(yaml.reverse)
        feathers = hash[:plumoj].reverse.inject("") { |s, c| s << c }.to_i
        color = hash[:koloro].split('\/')[1]
        Wingdom.new(file_id, feathers, color)
      end
    end

    herbert = Person.new('herbert')
    herbert['address'] = '103 Choctaw Dr'
    herbert['birthday'] = Date.parse('2/4/1979')
    herbert.save

    also_herbert = Person.find("herbert")
    also_herbert = Person.find(:first, "herb*")
    herbs = Person.find("herb*")
    herbs = Person.find(:all, "herb*")

## License

(The MIT License)

Copyright (c) 2008 Clinton R. Nixon of Viget Labs

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
