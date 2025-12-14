module GdDoc
  module Formatter
    class Base
      def file_path
        File.join(GdDoc.config.doc_dir, file_name)
      end
    end
  end
end
