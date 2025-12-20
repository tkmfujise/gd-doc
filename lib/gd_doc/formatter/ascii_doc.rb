module GdDoc
  module Formatter
    class AsciiDoc
      attr_accessor :project, :scenes, :scripts, :resources

      def initialize(composer, &block)
        self.project   = AsciiDoc::Project.new(composer.project)
        self.scenes    = composer.scenes.map{|s| AsciiDoc::Scene.new(s) }
        self.scripts   = composer.scripts.map{|s| AsciiDoc::Script.new(s) }
        self.resources = composer.resources.map{|r| AsciiDoc::Resource.new(r) }
        if block_given?
          yield project
          scenes.each   {|s| yield s }
          scripts.each  {|s| yield s }
          resources.each{|r| yield r }
        end
      end
    end
  end
end
