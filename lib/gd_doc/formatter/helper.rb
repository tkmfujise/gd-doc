module GdDoc
  module Formatter
    module Helper
      def split_slush(str)
        str.gsub('/', ' / ')
      end
    end
  end
end
