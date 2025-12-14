module GdDoc
  module TreeNodeHelper
    def dig(base, *keys)
      target = base
      keys.each do |key|
        target = target.children.find{|c| c.type == key }
        return nil unless target
      end
      target
    end
  end
end

