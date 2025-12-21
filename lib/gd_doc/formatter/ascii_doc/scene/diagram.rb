module GdDoc
  module Formatter
    class AsciiDoc::Scene::Diagram
      attr_accessor :scene

      def initialize(scene)
        self.scene = scene
      end

      # TODO
      def format
        <<~ASCIIDOC
        [plantuml]
        ....
        class Foo
        ....
        ASCIIDOC
      end
    end
  end
end

