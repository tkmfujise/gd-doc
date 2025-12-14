module GdDoc
  class Constant
    include TreeNodeHelper
    attr_accessor :name, :type, :static

    def initialize(root)
      self.static = false
      parse(root)
    end

    def parse(root)
      self.name   = dig(root, :name)&.text
      self.static = !dig(root, :static_keyword).nil?
      self.type   = dig(root, :type, :identifier)&.text
    end
  end
end

