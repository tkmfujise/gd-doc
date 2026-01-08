module GdDoc::TreeNode
  class ExtResource < Base
    ASSET_CLASSES = %w[
      GdDoc::Asset::Image
    ]

    attr_accessor :id, :path, :name, :instance

    def initialize(id)
      self.id = id
    end

    def to_s
      "ExtResource(#{format_value(id)})"
    end

    def asset?
      instance && ASSET_CLASSES.include?(instance.class.to_s)
    end
  end
end

