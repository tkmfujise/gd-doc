module GdDoc::TreeNode
  class Function < Base
    # see: https://docs.godotengine.org/en/stable/tutorials/scripting/overridable_functions.html
    OVERRIDABLE_VIRTUALS = %w[
      _enter_tree
      _exit_tree
      _init
      _ready
      _process
      _physics_process
      _unhandled_input
      _input
      _gui_input
      _draw
    ]

    attr_accessor(
      :name,
      :parameters,
      :return_type,
      :static,
      :text,
    )

    def initialize(root)
      self.text   = root.text
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
          FunctionParameter.select(child).each do |node|
            self.parameters << FunctionParameter.new(node)
          end
        when :type
          self.return_type = child.text
        when :static_keyword
          self.static = true
        end
      end
    end


    def overridden_virtual?
      OVERRIDABLE_VIRTUALS.include?(name)
    end
  end
end
