module GdDoc::TreeNode
  class SubResource < Base
    attr_accessor :id, :name

    def initialize(id)
      self.id = id
    end

    def to_s
      "SubResource(#{format_value(id)})"
    end
  end
end

