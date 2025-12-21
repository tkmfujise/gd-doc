module GdDoc::TreeNode
  class Argument < Base
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

    def to_s
      format_value(value)
    end
  end
end

