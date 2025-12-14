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

    def cast_value(value)
      case value.type
      when :integer
        value.text.to_i
      when :float
        value.text.to_f
      when :string
        value.text[1..-2]
      when :constructor
        Constructor.new(value)
      else
        value.text
      end
    end
  end
end

