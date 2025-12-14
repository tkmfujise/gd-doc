module GdDoc
  class Signal
    include TreeNodeHelper
    attr_accessor :name, :parameters

    def initialize(root)
      self.parameters = []
      parse(root)
    end

    def parse(root)
      self.name = dig(root, :name)&.text
      Parameter.select(root).each do |node|
        self.parameters << Parameter.new(node)
      end
    end
  end
end

