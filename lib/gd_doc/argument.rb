module GdDoc
  class Argument
    include TreeNodeHelper
    attr_accessor :value

    def self.select(root)
      node = root.children.find{|c| c.type == :arguments }
      if node
        node.children.reject{|c|
          [:"(", :")", :","].include?(c.type)
        }
      else
        []
      end
    end

    def initialize(root)
      parse(root)
    end

    def parse(root)
      self.value = cast_value(root)
    end
  end
end

