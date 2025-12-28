require 'spec_helper'

RSpec.describe GdDoc::Formatter::AsciiDoc::Scene do
  describe '#initialze' do
    subject { described_class.new(scene) }
    let(:scene) { GdDoc::Scene.new(file) }
    let(:file) { Tempfile.new.tap{|f| File.write f, src } }

    context 'basic' do
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
        expect{ subject.format }.not_to raise_error
      end
    end


    context 'animation pattern 1' do
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
        expect{ subject.format }.not_to raise_error
      end
    end


    context 'animation pattern 2' do
      let(:src) {
        <<~TSCN
          [gd_scene load_steps=99 format=3 uid="uid://byi6b08jpb2iw"]

          [node name="RedRobot" type="CharacterBody3D"]
          collision_layer = 3
          collision_mask = 3

          [sub_resource type="Animation" id="Animation_awjuk"]
          resource_name = "Cannon-L"
          length = 0.001
          tracks/0/type = "position_3d"
          tracks/0/imported = true
          tracks/0/enabled = true
          tracks/0/path = NodePath("Armature/Skeleton3D:MASTER")
          tracks/0/interp = 1
          tracks/0/loop_wrap = true
          tracks/0/keys = PackedFloat32Array(0, 1, 0, -1.1106, 0)
          tracks/1/type = "rotation_3d"
          tracks/1/imported = true
          tracks/1/enabled = true
          tracks/1/path = NodePath("Armature/Skeleton3D:MASTER")
          tracks/1/interp = 1
          tracks/1/loop_wrap = true
          tracks/1/keys = PackedFloat32Array(0, 1, 0, 0, 0, 1)
          tracks/2/type = "position_3d"
          tracks/2/imported = true
          tracks/2/enabled = true
          tracks/2/path = NodePath("Armature/Skeleton3D:Body")
          tracks/2/interp = 1
          tracks/2/loop_wrap = true
          tracks/2/keys = PackedFloat32Array(0, 1, 0, 1.1106, 0)
          tracks/3/type = "rotation_3d"
          tracks/3/imported = true
          tracks/3/enabled = true
          tracks/3/path = NodePath("Armature/Skeleton3D:Body")
          tracks/3/interp = 1
          tracks/3/loop_wrap = true
          tracks/3/keys = PackedFloat32Array(0, 1, 0, 0, 0, 1)
        TSCN
      }

      it 'works' do
        expect{ subject }.not_to raise_error
        expect{ subject.format }.not_to raise_error
      end
    end
  end
end

