require 'tree_stand'

module GdDoc
  class Parser < Collector
    class << self
      attr_accessor :name, :store_raw_data

      def parser
        TreeStand::Parser.new(name)
      end

      def parse(text)
        parser.parse_string(text).root_node
      end
    end

    include TreeNodeHelper

    attr_accessor :raw_data

    def initialize(file)
      super
      root = self.class.parse(File.read(file))
      self.raw_data = root.text if self.class.store_raw_data
      parse(root)
    end

    def parse(root)
      # Override this method
    end
  end
end

