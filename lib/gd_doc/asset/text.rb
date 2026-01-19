module GdDoc
  class Asset::Text < Collector
    self.extensions = GdDoc.config.asset_text_extensions

    attr_accessor :attached_scenes, :content, :extension

    def initializer
      self.content = File.read(file)
      self.extension = path.split('.')[-1]
      self.attached_scenes = Set.new
    end
  end
end
