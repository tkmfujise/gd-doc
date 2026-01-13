module GdDoc
  module Formatter
    class AsciiDoc
      attr_accessor(
        :project,
        :scenes,
        :scripts,
        :resources,
        :asset_images,
      )

      def initialize(composer, &block)
        self.project   = AsciiDoc::Project.new(
            composer.project,
            scenes:       composer.scenes,
            scripts:      composer.scripts,
            resources:    composer.resources,
            asset_images: composer.asset_images,
          )

        self.scenes    = composer.scenes.map{|s| AsciiDoc::Scene.new(s) }
        self.scripts   = composer.scripts.map{|s| AsciiDoc::Script.new(s) }
        self.resources = composer.resources.map{|r| AsciiDoc::Resource.new(r) }
        self.asset_images = composer.asset_images.map{|i| AsciiDoc::Asset::Image.new(i) }

        if block_given?
          yield project
          scenes.each      {|s| yield s }
          scripts.each     {|s| yield s }
          resources.each   {|r| yield r }
          asset_images.each{|i| yield i }
        end
      end
    end
  end
end
