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

    context 'animation' do
      let(:src) {
        <<~TSCN
          [gd_scene load_steps=34 format=3 uid="uid://foobar"]

          [node name="Player" type="CharacterBody2D"]

          [sub_resource type="Animation" id="Animation_sdj2t"]
          resource_name = "jump_left"
          length = 0.25
          loop_mode = 1
          step = 0.125
          tracks/0/type = "value"
          tracks/0/imported = false
          tracks/0/enabled = true
          tracks/0/path = NodePath("Sprites/SpriteStates/IdleSprite2D:visible")
          tracks/0/interp = 1
          tracks/0/loop_wrap = true
          tracks/0/keys = {
          "times": PackedFloat32Array(0),
          "transitions": PackedFloat32Array(1),
          "update": 1,
          "values": [false]
          }
          tracks/1/type = "value"
          tracks/1/imported = false
          tracks/1/enabled = true
          tracks/1/path = NodePath("Sprites/SpriteStates/RunSprite2D:visible")
          tracks/1/interp = 1
          tracks/1/loop_wrap = true
          tracks/1/keys = {
          "times": PackedFloat32Array(0),
          "transitions": PackedFloat32Array(1),
          "update": 1,
          "values": [false]
          }
          tracks/2/type = "value"
          tracks/2/imported = false
          tracks/2/enabled = true
          tracks/2/path = NodePath("Sprites:position")
          tracks/2/interp = 1
          tracks/2/loop_wrap = true
          tracks/2/keys = {
          "times": PackedFloat32Array(0),
          "transitions": PackedFloat32Array(1),
          "update": 0,
          "values": [Vector2(-12, -72)]
          }
          tracks/3/type = "value"
          tracks/3/imported = false
          tracks/3/enabled = true
          tracks/3/path = NodePath("Sprites/SpriteStates/JumpSprite2D:visible")
          tracks/3/interp = 1
          tracks/3/loop_wrap = true
          tracks/3/keys = {
          "times": PackedFloat32Array(0),
          "transitions": PackedFloat32Array(1),
          "update": 1,
          "values": [true]
          }
          tracks/4/type = "value"
          tracks/4/imported = false
          tracks/4/enabled = true
          tracks/4/path = NodePath("Sprites/SpriteStates/FallSprite2D:visible")
          tracks/4/interp = 1
          tracks/4/loop_wrap = true
          tracks/4/keys = {
          "times": PackedFloat32Array(0),
          "transitions": PackedFloat32Array(1),
          "update": 1,
          "values": [false]
          }
          tracks/5/type = "value"
          tracks/5/imported = false
          tracks/5/enabled = true
          tracks/5/path = NodePath("Sprites/SpriteStates/JumpSprite2D:flip_h")
          tracks/5/interp = 1
          tracks/5/loop_wrap = true
          tracks/5/keys = {
          "times": PackedFloat32Array(0),
          "transitions": PackedFloat32Array(1),
          "update": 1,
          "values": [false]
          }
          tracks/6/type = "value"
          tracks/6/imported = false
          tracks/6/enabled = true
          tracks/6/path = NodePath("Sprites/SpriteStates/JumpSprite2D:frame")
          tracks/6/interp = 1
          tracks/6/loop_wrap = true
          tracks/6/keys = {
          "times": PackedFloat32Array(0, 0.125),
          "transitions": PackedFloat32Array(1, 1),
          "update": 1,
          "values": [0, 1]
          }
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.animations.count).to eq 1
        expect(subject.animations[0]).to be_a(GdDoc::Scene::Animation)
        expect(subject.animations[0].name).to eq 'jump_left'
        expect(subject.animations[0].length).to eq 0.25
        expect(subject.animations[0].loop).to eq true
        expect(subject.animations[0].step).to eq 0.125
        expect(subject.animations[0].tracks.count).to eq 7
        expect(subject.animations[0].tracks[0]).to be_a(GdDoc::Scene::Animation::Track)
        expect(subject.animations[0].tracks[0].order).to eq 0
        expect(subject.animations[0].tracks[0].type).to eq 'value'
        expect(subject.animations[0].tracks[0].imported).to eq false
        expect(subject.animations[0].tracks[0].interp).to eq 1
        expect(subject.animations[0].tracks[0].loop_wrap).to eq true
        expect(subject.animations[0].tracks[0].keys).to eq({
          times: [0],
          transitions: [1],
          update: '1',
          values: ['false'],
        })
      end
    end
  end
end


