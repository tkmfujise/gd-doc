module GdDoc::TreeNode
  class SubResource < Base
    attr_accessor :value, :name

    def initialize(value)
      self.value = value
    end

    def to_s
      "SubResource(#{format_value(value)})"
    end
  end
end

