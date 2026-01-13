module GdDoc
  module CoreExt
    module NumericExt
      def human_size
        units = %w[B KB MB GB TB]
        size  = self.to_f
        unit  = 0

        while size >= 1024 && unit < units.length - 1
          size /= 1024
          unit += 1
        end

        "#{size.round(2)} #{units[unit]}"
      end
    end
  end
end


Integer.prepend GdDoc::CoreExt::NumericExt
Float.prepend GdDoc::CoreExt::NumericExt

