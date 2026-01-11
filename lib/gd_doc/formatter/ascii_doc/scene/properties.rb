module GdDoc
  module Formatter
    class AsciiDoc::Scene::Properties
      include Helper
      attr_accessor :scene

      def initialize(scene)
        self.scene   = scene
      end

      def format
        scene.nodes.map{|node|
          next '' if node.section.properties.empty?
          title = node.root? \
            ? '#Root# properties' \
            : "#$#{node.path}# properties"

          content = node.section.properties.map{|prop|
              "|*#{prop.name}* a|#{value_of(node, prop)}"
            }.join("\n")

          <<~TEXT
          [.node-property.node-#{node_class(node)}]
          .#{title}
          [cols="1,3" options="header"]
          |===
          |Name |Value
          #{content}
          |===
          TEXT
        }.join
      end

      private
        def value_of(node, prop)
          val = "`#{prop.formatted_value}`"
          ext = node.ext_resources.find{|n| n.name == prop.name }
          return val unless ext
          case ext.instance
          when GdDoc::Asset::Image
            <<~TEXT
            [link=#{content_link(ext.instance)}]
            [.asset-image]
            .#{ext.instance.path}
            image::#{asset_raw_link(ext.instance)}[]
            TEXT
          when GdDoc::Script
            "link:#{content_link(ext.instance)}[#{ext.instance.path}]"
          else
            if ext.path.to_s.end_with?('.tscn')
              link = ext.path.sub('res://', 'scenes/')
              "link:/#{link}[#{ext.path}]"
            else
              val
            end
          end
        end
    end
  end
end
