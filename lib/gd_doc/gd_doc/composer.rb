module GdDoc
  class Composer
    attr_accessor :project, :resources, :scripts

    def initialize
      self.project   = Project.build
      self.resources = Resource.build_all
      self.scripts   = Script.build_all.map{|s| [s.path, s] }.to_h
      combine_resources_and_scripts
    end

    private
      def combine_resources_and_scripts
        resources.each do |resource|
          next unless resource.script_path
          resource.script = scripts[resource.script_path]
        end
      end
  end
end
