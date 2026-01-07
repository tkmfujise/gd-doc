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
        title: Home
        application_name: #{project.name}
        ---

        #{welcome_message}

        === Main Scene
        #{main_scene}

        === Autoloads
        #{autoloads}

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

        
        def autoloads
          return 'NOTE: No autoloads' unless project.autoloads.any?
          content = project.autoloads.map{|a|
              link = a.path.dup
              link['res://'] =  \
                if    a.scene?  then '/scenes/'
                elsif a.script? then '/scripts/'
                else
                  '/'
                end

              "|_#{a.name}_ |link:#{link}[#{a.path}]"
            }.join("\n")
          <<~TEXT
          [cols="1,3" options="header"]
          |===
          |Name |Path
          #{content}
          |===
          TEXT
        end

        
        def properties
          content = project.sections.flat_map{|section|
              section.properties.map{|prop|
                "|_#{section.name}_ |*#{prop.name}* |`#{prop.formatted_value}`"
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

