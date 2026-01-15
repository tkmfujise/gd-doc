module GdDoc
  module Formatter
    class AsciiDoc::Project::Stats
      include Helper
      attr_accessor(
        :scenes,
        :scripts,
        :resources,
        :asset_images,
      )

      def initialize(composer)
        self.scenes       = composer.scenes
        self.scripts      = composer.scripts
        self.resources    = composer.resources
        self.asset_images = composer.asset_images
      end

      def format
        <<~ASCIIDOC
        [options="header"]
        |===
        | | | Min | Mean | Max | All

        #{section_for('🎬 Scenes', scenes, {
          'Child Nodes' => [->{ child_nodes.count }, 'nodes'],
        })}

        #{section_for('📝 Scripts', scripts, {
          'Functions' => [->{ functions.count }, 'funcs'],
          'Lines / Func' => [->{ functions.map{|f| f.text.lines.count } }, 'lines'],
        })}

        #{section_for('📊 Resources', resources, {
          'Properties' => [->{ sections.flat_map(&:properties).count }, 'props'],
        })}

        #{section_for('💠 Asset Images', asset_images, {
          'Content Length' => [->{ meta.content_length }, '', :human_size],
        })}
        |===
        ASCIIDOC
      end

      private
        def section_for(name, arr, counts)
          content = counts.map{|name, (lmd, unit, type)|
              unit_str = unit.empty? ? '' : "_#{unit}_"
              if arr.any?
                summary = summarize(arr.map{|a| a.instance_exec(&lmd) })
                <<~TEXT
                | *#{name}*
                | #{format_cell arr, summary, :min, type, unit_str}
                | #{format_cell arr, summary, :mean, type, unit_str}
                | #{format_cell arr, summary, :max, type, unit_str}
                | #{format_cell arr, summary, :all, type, unit_str}
                TEXT
              else
                <<~TEXT
                | *#{name}*
                | -
                | -
                | -
                | #{format_number 0, type} #{unit_str}
                TEXT
              end
            }.join

          <<~TEXT
            .#{counts.size}+| *#{name}* +
            #{delimited arr.count} _files_

            #{content}
          TEXT
        end


        #
        # summarize [1, [2, 3]]
        # => {
        #   all:     6,
        #   min:     1,
        #   min_idx: 0,
        #   mean:    2,
        #   max:     3,
        #   max_idx: 1,
        # }
        #
        def summarize(arr)
          flat = arr.flatten
          if flat.any?
            sum  = flat.sum
            min, max = flat.minmax
            {
              all:     sum,
              min:     min || 0,
              min_idx: arr.index{|v| v.is_a?(Array) ? v.include?(min) : v == min },
              mean:    (sum.to_f / flat.count).ceil(1),
              max:     max || 0,
              max_idx: arr.index{|v| v.is_a?(Array) ? v.include?(max) : v == max },
            }
          else
            {
              all:     0,
              min:     0,
              min_idx: 0,
              mean:    0,
              max:     0,
              max_idx: 0,
            }
          end
        end


        def format_cell(arr, summary, key, type, unit)
          str = format_number(summary[key], type)
          case key
          when :min
            "link:#{content_link(arr[summary[:min_idx]])}[#{str} #{unit}]"
          when :max
            "link:#{content_link(arr[summary[:max_idx]])}[#{str} #{unit}]"
          else
            "#{str} #{unit}"
          end
        end


        def format_number(value, type)
          case type
          when :human_size
            value.human_size
          else
            delimited(value)
          end
        end


        #
        # delimited 1234     => '1,234'
        # delimited 123.4    => '123.4'
        # delimited '1.2 GB' => '1.2 GB'
        #
        def delimited(number)
          case number
          when Numeric
            int, frac = number.to_s.split('.', 2)
            int = int.reverse.scan(/\d{1,3}/).join(',').reverse
            frac ? "#{int}.#{frac}" : int
          else
            number
          end
        end
    end
  end
end
