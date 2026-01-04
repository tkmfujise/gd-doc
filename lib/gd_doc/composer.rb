module GdDoc
  class Composer
    attr_accessor :project, :resources, :scenes, :scripts

    def initialize
      self.project   = Project.build
      self.resources = Resource.build_all
      self.scenes    = Scene.build_all
      self.scripts   = Script.build_all
      combine_scenes_and_scripts
      combine_scenes_to_children
    end


    def format(formatter, &block)
      formatter.new(self, &block)
    end


    private
      def combine_scenes_and_scripts
        scripts_hash = scripts.map{|s| [s.path, s] }.to_h
        scenes.each do |scene|
          scene.combine_scripts(scripts_hash)
        end
      end

      def combine_scenes_to_children
        scenes_hash = scenes.map{|s| [s.uid, s] }.to_h

        scenes.each do |scene|
          if project.main_scene_path == scene.path
            project.main_scene = scene
          end

          scene.nodes.select(&:instance).each do |node|
            target = scenes_hash[node.scene_uid]
            node.scene = target if target
          end
        end
      end
  end
end
