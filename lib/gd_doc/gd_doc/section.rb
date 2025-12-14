module GdDoc
  class Section
    include TreeNodeHelper
    attr_accessor :name, :attributes, :properties

    def initialize(root)
      self.attributes = []
      self.properties = []
      parse(root)
    end

    def parse(root)
      self.name = dig(root, :identifier)&.text
      root.children.each do |child|
        case child.type
        when :attribute
          self.attributes << Attribute.new(child)
        when :property
          self.properties << Property.new(child)
        end
      end
    end
  end
end


