module GdDoc
  class Script < Parser
    self.name = 'gdscript'
    self.extensions = ['gd']
    self.store_raw_data = true

    attr_accessor(
      :extends,
      :class_name,
      :signals,
      :functions,
      :variables,
      :constants,
    )

    def initializer
      self.signals   = []
      self.functions = []
      self.variables = []
      self.constants = []
    end

    def parse(root)
      root.each do |child|
        case child.type
        when :extends_statement
          self.extends = dig(child, :type, :identifier)&.text
        when :class_name_statement
          self.class_name = dig(child, :name)&.text
        when :signal_statement
          self.signals << TreeNode::Signal.new(child)
        when :function_definition
          self.functions << TreeNode::Function.new(child)
        when :variable_statement
          self.variables << TreeNode::Variable.new(child)
        when :const_statement
          self.constants << TreeNode::Constant.new(child)
        end
      end
    end
  end
end
