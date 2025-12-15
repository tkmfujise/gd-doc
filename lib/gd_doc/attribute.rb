module GdDoc
  class Attribute
    include TreeNodeHelper
    attr_accessor :name, :value

    def initialize(root)
      parse(root)
    end

    def parse(root)
      self.name  = root.children.first.text
      self.value = cast_value(root.children.last)
    end
  end
end
