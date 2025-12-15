module GdDoc::TreeNode
  class Variable < Base
    attr_accessor :name, :type, :static, :annotations

    def initialize(root)
      self.static = false
      self.annotations = []
      parse(root)
    end

    def parse(root)
      self.name   = dig(root, :name)&.text
      self.static = !dig(root, :static_keyword).nil?
      self.type   = dig(root, :type, :identifier)&.text
      self.annotations = dig(root, :annotations)&.map &:text || []
    end
  end
end

