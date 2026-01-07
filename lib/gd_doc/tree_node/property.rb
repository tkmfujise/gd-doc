module GdDoc::TreeNode
  class Property < Base
    attr_accessor :name, :value

    def initialize(root)
      parse(root)
    end

    def parse(root)
      self.name  = root.children.first.text
      self.value = cast_value(root.children.last)
    end

    def formatted_value
      if value.nil?
        'null'
      else
        value
      end
    end
  end
end

