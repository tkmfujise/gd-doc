require 'fastimage'

module GdDoc
  class Asset::Image < Collector
    self.extensions = %w[png jpg jpeg bmp svg] 

    attr_accessor :meta, :attached_scenes

    def initializer
      self.meta  = FastImage.new(file)
      self.attached_scenes = Set.new
    end


    def byte_size
      meta.content_length.human_size
    end
  end
end

