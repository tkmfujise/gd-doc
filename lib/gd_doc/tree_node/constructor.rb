module GdDoc::TreeNode
  class Constructor < Base
    attr_accessor :name, :arguments

    def initialize(root)
      self.arguments = []
      parse(root)
    end

    def parse(root)
      self.name  = root.children.first.text
      Argument.select(root).each do |child|
        self.arguments << Argument.new(child)
      end
    end

    def to_s
      "#{name}(#{arguments.map(&:to_s).join(', ')})"
    end
  end
end


