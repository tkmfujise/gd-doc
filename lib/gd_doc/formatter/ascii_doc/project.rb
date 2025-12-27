module GdDoc
  module Formatter
    class AsciiDoc::Project < Base
      attr_accessor :project

      def initialize(project)
        self.project = project
      end

      def file_name
        'index.adoc'
      end

      def format
        <<~ASCIIDOC
        ---
        title: #{project.name}
        application_name: #{project.name}
        ---

        #{welcome_message}

        === Main Scene
        #{main_scene}

        === Properties
        #{properties}

        ASCIIDOC
      end


      private
        def welcome_message
          <<~TEXT
          [.welcome-code]
          ```gdscript
          ▖  ▖  ▜            ▗        ▌   ▌      
          ▌▞▖▌█▌▐ ▛▘▛▌▛▛▌█▌  ▜▘▛▌  ▛▌▛▌▄▖▛▌▛▌▛▘  
          ▛ ▝▌▙▖▐▖▙▖▙▌▌▌▌▙▖  ▐▖▙▌  ▙▌▙▌  ▙▌▙▌▙▖▗ 
                                   ▄▌            

          Usage

          $ rake  # Analyze your Godot project, generate AsciiDoc files, and start the server.
          ```
          TEXT
        end


        def main_scene
          return 'CAUTION: This project has no main scene.' unless project.main_scene
          <<~TEXT
          * link:/scenes/#{project.main_scene.relative_path}[#{project.main_scene.path}]
          TEXT
        end

        
        def properties
          content = project.sections.flat_map{|section|
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

