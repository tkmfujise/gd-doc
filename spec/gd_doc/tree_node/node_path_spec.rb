require 'spec_helper'

RSpec.describe GdDoc::TreeNode::NodePath do
  let(:node_path) { described_class.new(value) }
  let(:value) { 'res://src/player/player.tscn' }

  describe '#to_s' do
    subject { node_path.to_s }

    it 'works' do
      is_expected.to match(/NodePath\(.+\)/)
    end
  end
end
