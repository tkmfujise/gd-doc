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
  end
end

