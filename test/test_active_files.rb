require File.join(File.dirname(__FILE__), 'test_helper')

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

class TestActiveFiles < Test::Unit::TestCase

  context "with a base directory" do
    setup do
      dirname = File.join(File.dirname(__FILE__), 'sample_data')
      ActiveFiles.base_dir = dirname
    end

    teardown do
      FileUtils.rm_rf(File.join(File.dirname(__FILE__), 'sample_data'))
    end

    should "be able to save a new object" do
      p = Person.new('test')
      expect(p.save).to.be true
      expect(File.exist?(p.send(:filename))).to.be true
    end

    should "be able to save and reload an insane object" do
      w = Wingdom.new('cardinal', 1372, 'red')
      w.save

      w = Wingdom.find('cardinal')
      expect(w.feathers).to.be 1372
      expect(w.color).to.be 'red'
    end

    context "with an existing object" do
      setup do
        @herbert = Person.new('Herbert')
        @herbert[:birthday] = Date.parse('February 4, 1979')
        @herbert.save
      end

      should "be able to find object" do
        p = Person.find('Herbert')
        expect(p).not.to.be.nil
        expect(p).is_a Person
        expect(p[:birthday]).to.equal Date.parse('2/4/1979')
      end

      should "be able to delete object" do
        @herbert.delete
        expect(File.exist?(@herbert.send(:filename))).not.to.be true
      end
    end

    context "with more than one existing object" do
      setup do
        3.times do |i|
          Person.new("person_#{i}").save
        end
      end

      should "be able to find many by globbing" do
        expect(Person.find('person*').size).to.be 3
      end

      should "be able to find first by globbing" do
        person = Person.find(:first, 'person*')
        expect(person).is.kind_of Person
        expect(person.file_id).to.be 'person_1'
      end
    end

    context "with no matching elements" do
      setup do
        Person.find(:all, "b*").each do |person|
          person.delete
        end
      end

      should "raise an error when simple finding" do
        expect(ActiveFiles::FileNotFound).to.be.raised_by do
          Person.find('bill')
        end
      end

      should "return nil when explicitly finding first" do
        expect(Person.find(:first, 'bill')).to.be.nil
      end

      should "return an empty array when explicitly finding all" do
        expect(Person.find(:all, 'b*')).to.be.empty
      end
    end
  end

end
