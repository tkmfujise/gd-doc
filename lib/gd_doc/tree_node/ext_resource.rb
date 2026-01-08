module GdDoc::TreeNode
  class ExtResource < Base
    attr_accessor :value, :name

    def initialize(value)
      self.value = value
    end

    def to_s
      "ExtResource(#{format_value(value)})"
    end
  end
end

