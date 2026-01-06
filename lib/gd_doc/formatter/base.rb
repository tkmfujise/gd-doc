module GdDoc
  module Formatter
    class Base
      include Helper

      def file_path
        content_path_for(file_name)
      end

      def content_path_for(name)
        Pathname(File.join(GdDoc.config.doc_dir, 'content', name))
      end

      def file_name
        raise 'Override this method'
      end

      def format
        raise 'Override this method'
      end


      # e.g.) { 'path/to/image.png' => 'assets/images/image.png' }
      def store_file_paths
        Hash.new
      end
    end
  end
end
