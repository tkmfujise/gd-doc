module GdDoc
  class Project < Parser
    self.name = 'godot-resource'
    self.extensions = ['godot']

    class Autoload
      attr_accessor :name, :path, :instance

      def self.build(section)
        section.properties.map{|prop|
          new(prop.name, prop.value)
        }
      end

      def initialize(name, path)
        self.name = name
        self.path = path.delete_prefix('*')
      end

      def scene?
        path.end_with? '.tscn'
      end

      def script?
        path.end_with? '.gd'
      end
    end


    attr_accessor(
      :properties,
      :sections,
      :name,
      :main_scene_path,
      :main_scene,
      :autoloads,
    )

    def initializer
      self.properties = []
      self.sections   = []
      self.autoloads  = []
    end


    def parse(root)
      root.children.each do |child|
        case child.type
        when :section
          section = TreeNode::Section.new(child)
          self.sections << section
          case section.name
          when 'autoload'
            self.autoloads = Autoload.build(section)
          end
        when :property
          self.properties << TreeNode::Property.new(child)
        end
      end

      self.name = value_of('application', 'config/name')
      self.main_scene_path = value_of('application', 'run/main_scene')
    end


    private
      def value_of(section_name, property_name)
        section = sections.find{|s| s.name == section_name }
        return nil unless section
        section.value_of(property_name)
      end
  end
end
