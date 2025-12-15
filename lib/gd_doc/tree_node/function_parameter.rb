module GdDoc::TreeNode
  class FunctionParameter < Base
    NODE_TYPES = %i[typed_parameter typed_default_parameter]
    attr_accessor :name, :type

    def self.select(root)
      root.children.select{|c|
        NODE_TYPES.include?(c.type)
      }
    end

    def initialize(root)
      parse(root)
    end

    def parse(root)
      self.name = dig(root, :identifier)&.text
      self.type = dig(root, :type, :identifier)&.text
    end
  end
end
