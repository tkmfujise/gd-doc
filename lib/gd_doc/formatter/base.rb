module GdDoc
  module Formatter
    class Base
      def file_path
        Pathname(File.join(GdDoc.config.doc_dir, 'content', file_name))
      end

      def file_name
        raise 'Override this method'
      end

      def format
        raise 'Override this method'
      end
    end
  end
end
