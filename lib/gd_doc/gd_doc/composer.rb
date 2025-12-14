module GdDoc
  class Composer
    attr_accessor :project, :resources, :scenes, :scripts

    def initialize
      self.project   = Project.build
      self.resources = Resource.build_all
      self.scenes    = Scene.build_all
      self.scripts   = Script.build_all.map{|s| [s.path, s] }.to_h
      combine_scenes_and_scripts
    end

    def asciidoc_formatter
      Formatter::AsciiDoc.new(self)
    end

    private
      def combine_scenes_and_scripts
        scenes.each do |scene|
          next unless scene.script_path
          scene.script = scripts[scene.script_path]
        end
      end
  end
end
