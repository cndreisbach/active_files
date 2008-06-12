class ActiveFiles::FileNotFound < Exception; end
class ActiveFiles::NoFileId < Exception; end

module ActiveFiles::Record
  def self.included(base)
    base.module_eval do
      extend ActiveFiles::Record::ClassMethods
    end
  end

  module ClassMethods
    # Adds a parameter to the beginning of initialize to accept a file_id.
    # If you run this, you must run it after your own initialize (or not have
    # an initialize at all.)
    #
    # Feel free to take care of file_id yourself somehow.    
    def add_file_id_to_initialize
      self.module_eval do
        def initialize_with_file_id(file_id, *args)
          self.file_id = file_id
          initialize_without_file_id(*args)
        end
        alias :initialize_without_file_id :initialize
        alias :initialize :initialize_with_file_id
      end
    end
    
    # Find. Tries way too hard to replicate ActiveRecord.
    #
    # Find operates with three different retrieval mechanisms.
    #
    # * Find by name: Enter a name, or a glob. If one record
    #   can be found matching that name, then only one is
    #   returned. If more than one can be found, an array
    #   is returned. If no record can be found,
    #   ActiveFiles::FileNotFound is thrown.
    #
    # * Find first (<tt>:first</tt>): This will return the
    #   first record matched by the options used. If no
    #   record can matched, nil is returned.
    #
    # * Find all (<tt>:all</tt>: This will return all the
    #   records matched by the options used. If no records
    #   are found, an empty array is returned.
    #
    # The last two approached accept an option hash as their
    # last parameter. The options are:
    # * <tt>:name => name</tt>:: Glob-based record name.
    def find(*args)
      name = '*'
      order = nil

      if (args.length == 1 and args[0].kind_of?(String)) then
        name = args[0]
        mode = :name
      elsif (args.first == :first or args.first == :all)
        mode = args.first
        options = extract_find_options!(args)
        name = options[:name] if options.has_key?(:name)
        order = options[:order] if options.has_key?(:order)
      else
        raise ArgumentError, "Unknown mode: #{args.first}"
      end

      files = Dir[File.join(self.file_store, name + ActiveFiles.ext)]
      
      if files.empty? then
        case mode
        when :name
          raise ActiveFiles::FileNotFound
        when :first
          return nil
        when :all
          return Array.new()
        end
      elsif (mode == :first or (mode == :name and files.length == 1)) then
        return self.from_activefile(File.read(files.first), self.parse_file_id(files.first))
      else
        objs = Array.new()
        files.each do |file|
          objs.push(self.from_activefile(File.read(file), self.parse_file_id(file)))
        end

        return case order
               when 'asc' then objs.sort { |a,b| a.file_id <=> b.file_id }
               when 'desc' then objs.sort { |a,b| b.file_id <=> a.file_id }
               else objs
               end
      end
    rescue Errno::ENOENT
      self.create_file_store
      self.find(*args)
    end

    # Directory in which this class's ActiveFiles are stored.
    def file_store
      File.join(ActiveFiles.base_dir, self.to_s)
    end

    def create_file_store
      FileUtils.mkdir_p(file_store) unless File.exists?(file_store)
    end

    protected
    
    def extract_find_options!(args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      unknown_options = options.keys - [:name, :order].flatten
      raise(ArgumentError, "Unknown key(s): #{unknown_options.join(", ")}") unless unknown_options.empty?
      options
    end

    def parse_file_id(file)
      File.basename(file, ActiveFiles.ext)
    end

    def from_activefile(yaml, file_id)
      obj = YAML::load(yaml)
      if obj.respond_to?(:file_id=)
        obj.send(:file_id=, file_id)
      end
      obj
    end
  end
  
  def save
    raise ActiveFiles::NoFileId if self.file_id.nil?
    File.open(filename, 'w') do |file|
      file.puts self.to_activefile
    end
    true
  rescue Errno::ENOENT
    self.class.create_file_store
    self.save
  end

  def delete
    File.delete(filename)
  end

  def file_id
    @file_id
  end

  protected

  def to_activefile
    self.to_yaml
  end

  def filename
    File.join(self.class.file_store, self.file_id + ActiveFiles.ext)
  end

  def file_id=(id)
    @file_id = id
  end

end
