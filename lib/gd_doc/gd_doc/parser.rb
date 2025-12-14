require 'tree_stand'

module GdDoc
  class Parser
    class << self
      attr_accessor :name, :extensions
    end

    
    def self.parser
      TreeStand::Parser.new(self.name)
    end

    def self.files
      Dir["#{GdDoc.config.project_dir}/**/*.#{self.extensions.join('|')}"]
    end

    attr_accessor(
      :file,
      :root,
    )

    def initialize(file)
      self.file = file
      self.root = self.class.parser.parse_string(File.read(file)).root_node
    end

    private
      def dig(base, *keys)
        target = base
        keys.each do |key|
          target = target.children.find{|c| c.type == key }
          return nil unless target
        end
        target
      end
  end
end

