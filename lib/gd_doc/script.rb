module GdDoc
  class Script < Parser
    self.name = 'gdscript'
    self.extensions = ['gd']

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
          self.signals << Signal.new(child)
        when :function_definition
          self.functions << Function.new(child)
        when :variable_statement
          self.variables << Variable.new(child)
        when :const_statement
          self.constants << Constant.new(child)
        end
      end
    end
  end
end
