module GdDoc::TreeNode
  class Parameter < Base
    NODE_TYPES = %i[identifier]
    attr_accessor :name

    def self.select(root)
      node = root.children.find{|c| c.type == :parameters }
      if node
        node.children.select{|c|
          NODE_TYPES.include?(c.type)
        }
      else
        []
      end
    end

    def initialize(root)
      parse(root)
    end

    def parse(root)
      self.name = root.text
    end
  end
end

