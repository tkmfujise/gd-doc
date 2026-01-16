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
          ext = node.ext_resources.find{|n| n.name == prop.name }
          return value_may_link_for(prop.formatted_value) unless ext
          case ext.instance
          when GdDoc::Asset::Image
            <<~TEXT
            [link=#{content_link(ext.instance)}]
            [.asset-image]
            .#{ext.instance.path}
            image::#{asset_raw_link(ext.instance)}[]
            TEXT
          when GdDoc::Script, GdDoc::Resource
            "link:#{content_link(ext.instance)}[#{ext.instance.path}]"
          else
            value_may_link_for(ext.path)
          end
        end


        def value_may_link_for(value)
          if value.to_s.end_with?('.tscn')
            link = value.sub('res://', 'scenes/')
            "link:/#{encode_link link}[#{value}]"
          elsif value.to_s.end_with?('.tres')
            link = value.sub('res://', 'resources/')
            "link:/#{encode_link link}[#{value}]"
          else
            "`#{value}`"
          end
        end
    end
  end
end
