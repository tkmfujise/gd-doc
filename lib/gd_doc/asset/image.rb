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
      format_byte(meta.content_length)
    end


    private
      def format_byte(bytes)
        units = %w[B KB MB GB TB]
        size  = bytes.to_f
        unit  = 0

        while size >= 1024 && unit < units.length - 1
          size /= 1024
          unit += 1
        end

        "#{size.round(2)} #{units[unit]}"
      end
  end
end

