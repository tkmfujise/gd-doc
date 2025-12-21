require 'spec_helper'

RSpec.describe GdDoc::Scene do
  describe '.files' do
    subject { GdDoc::Scene.files }
    it { is_expected.to be_a(Array) }
  end


  describe '.parser' do
    subject { GdDoc::Scene.parser }
    it { is_expected.to be_a(TreeStand::Parser) }
  end


  describe '#initialize' do
    subject { GdDoc::Scene.new(file) }

    context 'demo file' do
      let(:file) { GdDoc::Scene.files[0] }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.path).to start_with 'res://'
      end
    end
  end


  describe '#parse' do
    subject { GdDoc::Scene.new(file) }
    let(:file) { Tempfile.new.tap{|f| File.write f, src } }

    context 'plain' do
      let(:src) {
        <<~TSCN
          [gd_scene load_steps=34 format=3 uid="uid://foobar"]

          [node name="Main" type="Control"]
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.sections[0]).to be_a GdDoc::TreeNode::Section
        expect(subject.sections[0].name).to eq 'gd_scene'
        expect(subject.sections[0].attributes[0]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[0].attributes[0].name).to eq 'load_steps'
        expect(subject.sections[0].attributes[0].value).to eq 34
        expect(subject.sections[0].attributes[1]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[0].attributes[1].name).to eq 'format'
        expect(subject.sections[0].attributes[1].value).to eq 3
        expect(subject.sections[0].attributes[2]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[0].attributes[2].name).to eq 'uid'
        expect(subject.sections[0].attributes[2].value).to eq 'uid://foobar'
        expect(subject.uid).to eq 'uid://foobar'
      end
    end

    context 'simple' do
      let(:src) {
        <<~TSCN
          [gd_scene load_steps=34 format=3 uid="uid://foobar"]

          [node name="Main" type="Control"]

          [sub_resource type="ShaderMaterial" id="ShaderMaterial_brvuo"]
          shader = ExtScene("3_51v81")
          shader_parameter/sunny = 0.0
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.sections[1]).to be_a GdDoc::TreeNode::Section

        # attributes
        expect(subject.sections[2].attributes[0]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[2].attributes[0].name).to eq 'type'
        expect(subject.sections[2].attributes[0].value).to eq 'ShaderMaterial'
        expect(subject.sections[2].attributes[1]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[2].attributes[1].name).to eq 'id'
        expect(subject.sections[2].attributes[1].value).to eq 'ShaderMaterial_brvuo'

        # properties
        expect(subject.sections[2].properties[0]).to be_a GdDoc::TreeNode::Property
        expect(subject.sections[2].properties[0].name).to eq 'shader'
        expect(subject.sections[2].properties[0].value).to be_a GdDoc::TreeNode::Constructor
        expect(subject.sections[2].properties[0].value.name).to eq 'ExtScene'
        expect(subject.sections[2].properties[0].value.arguments[0]).to be_a GdDoc::TreeNode::Argument
        expect(subject.sections[2].properties[0].value.arguments[0].value).to eq '3_51v81'
        expect(subject.sections[2].properties[1]).to be_a GdDoc::TreeNode::Property
        expect(subject.sections[2].properties[1].name).to eq 'shader_parameter/sunny'
        expect(subject.sections[2].properties[1].value).to eq 0.0
      end
    end

    context 'script_path' do
      let(:src) {
        <<~TSCN
          [gd_scene load_steps=34 format=3 uid="uid://foobar"]

          [node name="Main" type="Control"]

          [ext_resource type="Script" uid="uid://barfoo" path="res://src/main.gd" id="1)eewff"]
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.script_path).to eq 'res://src/main.gd'
      end
    end

    context 'children' do
      let(:src) {
        <<~TSCN
          [gd_scene load_steps=42 format=3 uid="uid://c8777f6ryw7re"]

          [ext_resource type="PackedScene" uid="uid://bb3rohjwfowwf" path="res://src/player/camera/camera.tscn" id="8_x42xx"]

          [ext_resource type="Texture2D" uid="uid://cp4bljrqpo6mr" path="res://assets/images/player/Player_idle.png" id="2_byvol"]

          [sub_resource type="CapsuleShape2D" id="CapsuleShape2D_opnj4"]
          radius = 30.0
          height = 96.0

          [node name="Player" type="CharacterBody2D"]

          [node name="Sprites" type="Node2D" parent="."]
          unique_name_in_owner = true
          position = Vector2(-12, -72)

          [node name="SpriteStates" type="Node2D" parent="Sprites"]

          [node name="IdleSprite2D" type="Sprite2D" parent="Sprites/SpriteStates"]
          texture = ExtResource("2_byvol")

          [node name="CollisionShape2D" type="CollisionShape2D" parent="."]
          shape = SubResource("CapsuleShape2D_opnj4")

          [node name="Camera" parent="." instance=ExtResource("8_x42xx")]

          [node name="AnimationPlayer" type="AnimationPlayer" parent="."]
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.root_node.name).to eq 'Player'
        expect(subject.root_node.type).to eq 'CharacterBody2D'
        tree = %w[
          .
          Sprites
          Sprites/SpriteStates
          Sprites/SpriteStates/IdleSprite2D
          CollisionShape2D
          Camera
          AnimationPlayer
        ]
        expect(subject.nodes.count).to eq tree.count
        expect(subject.nodes.map(&:path)).to eq tree
        expect(subject.tree[0].name).to eq 'Player'
        expect(subject.tree[1].count).to eq 4
        expect(subject.tree.flatten.count).to eq tree.count
        expect(subject.tree.flatten.map(&:path)).to eq tree
      end
    end
  end
end


