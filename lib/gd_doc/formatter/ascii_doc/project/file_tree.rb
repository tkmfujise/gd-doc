module GdDoc
  module Formatter
    class AsciiDoc::Project::FileTree
      class Directory
        attr_accessor :parents, :entities, :followers

        def initialize(parents, entities)
          self.parents  = parents
          self.entities = entities
          self.followers = [true] * parents.count
        end

        def path
          if parents.any? 
            parents.join('/')
          else
            '.'
          end
        end

        def <=>(other)
          path <=> other.path
        end

        def depth
          parents.count - 1
        end

        def prefix
          return '.' if parents.none?
          txt = followers[depth] ? ' ├' : ' └'
          txt.prepend (parents.count - 1).times.map{|i|
            followers[i] ?  ' │' : ' └'
          }.join(' ')
          txt
        end

        # |│  ├  MokiTown |0 |0 |0 |0
        def format
          "|#{prefix} #{parents.last} #{counts}\n"
        end


        private
          def counts
            [scenes, scripts, resources, asset_images].map(&:count).map{|i|
              if i == 0
                "|[.zero]##{i}# "
              elsif i == 1
                "|[.one]##{i}# "
              else
                "|[.more]##{i}# "
              end
            }.join
          end

          def scenes
            entities.select{|e| e.kind_of? GdDoc::Scene }
          end

          def scripts
            entities.select{|e| e.kind_of? GdDoc::Script }
          end

          def resources
            entities.select{|e| e.kind_of? GdDoc::Resource }
          end

          def asset_images
            entities.select{|e| e.kind_of? GdDoc::Asset::Image }
          end
      end


      attr_accessor :directories

      def initialize(composer)
        self.directories = (
            composer.scenes \
            | composer.scripts \
            | composer.resources \
            | composer.asset_images
          ).group_by{|target|
            target.relative_path.split('/')[0..-2]
          }.map{|parents, entities|
            Directory.new(parents, entities)
          }.sort

        fill_directories
        set_directories_depth
      end


      def format
        <<~TEXT
          [.file-tree.grid]
          [cols="5,1,1,1,1" options="header"]
          |===
          |File Tree |🎬 |📝 |📊 |💠
          #{directories.map(&:format).join}
          |===
        TEXT
      end


      private
        def fill_directories
          all = directories.map(&:parents)
          missing = Set.new
          all.each do |parents|
            arr = parents.count.times.map{|i| parents[0..i] }
            arr.each do |a|
              unless all.include?(a) || missing.include?(a)
                missing << a
              end
            end
          end

          self.directories.concat missing.map{|parents|
            Directory.new(parents, [])
          }
          directories.sort!
        end


        # TODO 不要な罫線を削除
        def set_directories_depth
          current = []
          directories.each_with_index do |dir, i|
            next_dir = directories[i+1]
            if next_dir
              if dir.parents.count > next_dir.parents.count
                
                dir.followers[-1] = false
              end
            else
              dir.followers = [false] * dir.depth
            end
          end
        end
    end
  end
end
