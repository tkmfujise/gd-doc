module GdDoc
  module Formatter
    class AsciiDoc::Resource < Base
      attr_accessor :resource

      def initialize(resource)
        self.resource = resource
      end

      def file_name
        File.join('resources', "#{resource.relative_path}.adoc")
      end

      def format
        <<~ASCIIDOC
        ---
        title: #{resource.path}
        ---
        :toc:

        == #{splitted_path}

        === Properties
        #{properties}
        ASCIIDOC
      end

      private
        def splitted_path
          resource.relative_path.gsub('/', ' / ')
        end

        # TODO
        def properties
          content = resource.sections.flat_map{|section|
              section.properties.map{|prop|
                "|_#{section.name}_ |*#{prop.name}* |`#{prop.value}`"
              }
            }.join("\n")
          <<~TEXT
          [cols="1,1,3" options="header"]
          |===
          |Section |Name |Value
          #{content}
          |===
          TEXT
        end
    end
  end
end


