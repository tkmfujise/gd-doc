module GdDoc
  module Formatter
    class AsciiDoc::Project::FileTree
      class Directory
        attr_accessor :parents, :entries, :followers

        def initialize(parents, entries)
          self.parents = parents
          self.entries = entries
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
          "|#{prefix} #{parents.last} #{all_counts}\n"
        end

        def scenes
          entries.select{|e| e.kind_of? GdDoc::Scene }
        end

        def scripts
          entries.select{|e| e.kind_of? GdDoc::Script }
        end

        def resources
          entries.select{|e| e.kind_of? GdDoc::Resource }
        end

        def asset_images
          entries.select{|e| e.kind_of? GdDoc::Asset::Image }
        end

        private
          def all_counts
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
          }.map{|parents, entries|
            Directory.new(parents, entries)
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
