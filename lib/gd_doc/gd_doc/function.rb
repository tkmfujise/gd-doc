module GdDoc
  class Function
    include TreeNodeHelper
    attr_accessor :name, :parameters, :return_type, :static

    def initialize(root)
      self.static = false
      self.parameters = []
      parse(root)
    end

    def parse(root)
      root.children.each do |child|
        case child.type
        when :name
          self.name = child.text
        when :parameters
          child.children.select{|c|
            FunctionParameter::NODE_TYPES.include?(c.type)
          }.each do |node|
            self.parameters << FunctionParameter.new(node)
          end
        when :type
          self.return_type = child.text
        when :static_keyword
          self.static = true
        end
      end
    end
  end
end
