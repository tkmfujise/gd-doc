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
        constructor = TreeNode::Constructor.new(value)
        case constructor.name
        when 'ExtResource'
          TreeNode::ExtResource.new(constructor.arguments[0].value)
        when 'SubResource'
          TreeNode::SubResource.new(constructor.arguments[0].value)
        when 'NodePath'
          TreeNode::NodePath.new(constructor.arguments[0].value)
        else
          constructor
        end
      when :true
        true
      when :false
        false
      when :null
        nil
      else
        value.text
      end
    end

    def format_value(value)
      case value
      when String
        "\"#{value}\""
      else
        value.to_s
      end
    end
  end
end

