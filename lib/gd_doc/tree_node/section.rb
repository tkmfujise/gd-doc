module GdDoc::TreeNode
  class Section < Base
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


    def value_of(name)
      property_value_of(name) || attribute_value_of(name)
    end

    def property_value_of(name)
      properties.find{|s| s.name == name }&.value
    end

    def attribute_value_of(name)
      attributes.find{|s| s.name == name }&.value
    end


    def script?
      attributes.any?{|a| a.name == 'type' && a.value == 'Script' }
    end

    def root_node?
      name == 'node' && attributes.none?{|a| a.name == 'parent' }
    end

    def child_node?
      name == 'node' && attributes.any?{|a| a.name == 'parent' }
    end

    def connection_signal?
      name == 'connection' && attributes.any?{|a| a.name == 'signal' }
    end

    def animation?
      name = 'sub_resource' && attribute_value_of('type') == 'Animation'
    end

    def ext_resource?
      name == 'ext_resource'
    end

    def script_path
      if script?
        attributes.find{|a| a.name == 'path' }&.value
      else
        nil
      end
    end
  end
end


