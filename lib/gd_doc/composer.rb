module GdDoc
  class Composer
    attr_accessor :project, :resources, :scenes, :scripts

    def initialize
      self.project   = Project.build
      self.resources = Resource.build_all
      self.scenes    = Scene.build_all
      self.scripts   = Script.build_all
      combine_scenes_and_scripts
    end


    def format(formatter, &block)
      formatter.new(self, &block)
    end


    private
      def combine_scenes_and_scripts
        scripts_hash = scripts.map{|s| [s.path, s] }.to_h
        scenes.each do |scene|
          next unless scene.script_path
          scene.script = scripts_hash[scene.script_path]
        end
      end
  end
end
