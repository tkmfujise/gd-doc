module GdDoc
  module Formatter
    class AsciiDoc::Project < Base
      extend Forwardable
      delegate %i[project scenes scripts resources asset_images] => :composer
      attr_accessor :composer

      def initialize(composer)
        self.composer = composer
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

        === Stats
        #{Stats.new(composer).format}

        #{FileTree.new(composer).format}

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
          * link:#{content_link project.main_scene}[#{project.main_scene.path}]
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

              "|_#{a.name}_ |link:#{encode_link link}[#{a.path}]"
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
          ignoring_sections = %w(autoload)
          project.sections.flat_map{|section|
            next '' if ignoring_sections.include?(section.name)
            content = section.properties.map{|prop|
                <<~TEXT
                |*#{prop.name}* |`#{prop.formatted_value}`
                TEXT
              }.join("\n")
            <<~TEXT
            ==== #{section.name}
            [cols="1,3" options="header"]
            |===
            |Name |Value
            #{content}
            |===
            TEXT
          }.join("\n")
        end
    end
  end
end

