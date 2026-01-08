module GdDoc::TreeNode
  class NodePath < Base
    attr_accessor :value

    def initialize(value)
      self.value = value
    end

    def to_s
      "NodePath(#{format_value(value)})"
    end
  end
end


