module GdDoc
  class Composer
    attr_accessor(
      :project,
      :resources,
      :scenes,
      :scripts,
      :asset_images,
    )

    def initialize
      self.project   = Project.build
      self.resources = Resource.build_all
      self.scenes    = Scene.build_all
      self.scripts   = Script.build_all
      self.asset_images = Asset::Image.build_all
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
          project.set_main_scene_if_match(scene)

          scene.nodes.select(&:instance).each do |node|
            target = scenes_hash[node.scene_uid]
            if target
              node.scene = target
              target.instantiators << scene
            end
          end
        end
      end
  end
end
