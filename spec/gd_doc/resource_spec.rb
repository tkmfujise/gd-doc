require 'spec_helper'

RSpec.describe GdDoc::Resource do
  describe '.files' do
    subject { GdDoc::Resource.files }
    it { is_expected.to be_a(Array) }
  end


  describe '.parser' do
    subject { GdDoc::Resource.parser }
    it { is_expected.to be_a(TreeStand::Parser) }
  end


  describe '#initialize' do
    subject { GdDoc::Resource.new(file) }

    context 'demo file' do
      let(:file) { GdDoc::Resource.files[0] }
      it { expect{ subject }.not_to raise_error }
    end
  end


  describe '#parse' do
    subject { GdDoc::Resource.new(file) }
    let(:file) { Tempfile.new.tap{|f| File.write f, src } }

    context 'plain' do
      let(:src) {
        <<~TSCN
          [gd_scene load_steps=34 format=3 uid="uid://foobar"]
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.sections[0]).to be_a GdDoc::Section
        expect(subject.sections[0].name).to eq 'gd_scene'
        expect(subject.sections[0].attributes[0]).to be_a GdDoc::Attribute
        expect(subject.sections[0].attributes[0].name).to eq 'load_steps'
        expect(subject.sections[0].attributes[0].value).to eq 34
        expect(subject.sections[0].attributes[1]).to be_a GdDoc::Attribute
        expect(subject.sections[0].attributes[1].name).to eq 'format'
        expect(subject.sections[0].attributes[1].value).to eq 3
        expect(subject.sections[0].attributes[2]).to be_a GdDoc::Attribute
        expect(subject.sections[0].attributes[2].name).to eq 'uid'
        expect(subject.sections[0].attributes[2].value).to eq 'uid://foobar'
        expect(subject.uid).to eq 'uid://foobar'
      end
    end

    context 'simple' do
      let(:src) {
        <<~TSCN
          [gd_scene load_steps=34 format=3 uid="uid://foobar"]

          [sub_resource type="ShaderMaterial" id="ShaderMaterial_brvuo"]
          shader = ExtResource("3_51v81")
          shader_parameter/sunny = 0.0
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.sections[1]).to be_a GdDoc::Section

        # attributes
        expect(subject.sections[1].attributes[0]).to be_a GdDoc::Attribute
        expect(subject.sections[1].attributes[0].name).to eq 'type'
        expect(subject.sections[1].attributes[0].value).to eq 'ShaderMaterial'
        expect(subject.sections[1].attributes[1]).to be_a GdDoc::Attribute
        expect(subject.sections[1].attributes[1].name).to eq 'id'
        expect(subject.sections[1].attributes[1].value).to eq 'ShaderMaterial_brvuo'

        # properties
        expect(subject.sections[1].properties[0]).to be_a GdDoc::Property
        expect(subject.sections[1].properties[0].name).to eq 'shader'
        expect(subject.sections[1].properties[0].value).to be_a GdDoc::Constructor
        expect(subject.sections[1].properties[0].value.name).to eq 'ExtResource'
        expect(subject.sections[1].properties[0].value.arguments[0]).to be_a GdDoc::Argument
        expect(subject.sections[1].properties[0].value.arguments[0].value).to eq '3_51v81'
        expect(subject.sections[1].properties[1]).to be_a GdDoc::Property
        expect(subject.sections[1].properties[1].name).to eq 'shader_parameter/sunny'
        expect(subject.sections[1].properties[1].value).to eq 0.0
      end
    end

    context 'script_path' do
      let(:src) {
        <<~TSCN
          [gd_scene load_steps=34 format=3 uid="uid://foobar"]

          [ext_resource type="Script" uid="uid://barfoo" path="res://src/main.gd" id="1)eewff"]
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.script_path).to eq 'res://src/main.gd'
      end
    end
  end
end


