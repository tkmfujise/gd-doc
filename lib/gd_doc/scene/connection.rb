module GdDoc
  class Scene::Connection
    attr_accessor(
      :name,
      :from,
      :to,
      :method_name,
    )

    def initialize(section)
      self.name = section.attribute_value_of('signal')
      self.from = section.attribute_value_of('from')
      self.to   = section.attribute_value_of('to')
      self.method_name = section.attribute_value_of('method')
    end
  end
end
