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
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.path).to start_with 'res://'
      end
    end
  end


  describe '#parse' do
    subject { GdDoc::Resource.new(file) }
    let(:file) { Tempfile.new.tap{|f| File.write f, src } }

    context 'plain' do
      let(:src) {
        <<~TSCN
          [gd_resource type="Theme" load_steps=3 format=2 uid="uid://foobar"]
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.sections[0]).to be_a GdDoc::TreeNode::Section
        expect(subject.sections[0].name).to eq 'gd_resource'
        expect(subject.sections[0].attributes[0]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[0].attributes[0].name).to eq 'type'
        expect(subject.sections[0].attributes[0].value).to eq 'Theme'
        expect(subject.sections[0].attributes[1]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[0].attributes[1].name).to eq 'load_steps'
        expect(subject.sections[0].attributes[1].value).to eq 3
        expect(subject.sections[0].attributes[2]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[0].attributes[2].name).to eq 'format'
        expect(subject.sections[0].attributes[2].value).to eq 2
        expect(subject.sections[0].attributes[3]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[0].attributes[3].name).to eq 'uid'
        expect(subject.sections[0].attributes[3].value).to eq 'uid://foobar'
        expect(subject.uid).to eq 'uid://foobar'
      end
    end

    context 'simple' do
      let(:src) {
        <<~TSCN
          [gd_resource load_steps=34 format=3 uid="uid://foobar"]

          [sub_resource type="StyleBoxFlat" id="StyleBoxFlat_ht2pf"]
          bg_color = Color(0, 0.44705883, 0.23921569, 1)
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.sections[1]).to be_a GdDoc::TreeNode::Section

        # attributes
        expect(subject.sections[1].attributes[0]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[1].attributes[0].name).to eq 'type'
        expect(subject.sections[1].attributes[0].value).to eq 'StyleBoxFlat'
        expect(subject.sections[1].attributes[1]).to be_a GdDoc::TreeNode::Attribute
        expect(subject.sections[1].attributes[1].name).to eq 'id'
        expect(subject.sections[1].attributes[1].value).to eq 'StyleBoxFlat_ht2pf'

        # properties
        expect(subject.sections[1].properties[0]).to be_a GdDoc::TreeNode::Property
        expect(subject.sections[1].properties[0].name).to eq 'bg_color'
        expect(subject.sections[1].properties[0].value).to be_a GdDoc::TreeNode::Constructor
        expect(subject.sections[1].properties[0].value.name).to eq 'Color'
        expect(subject.sections[1].properties[0].value.arguments[0]).to be_a GdDoc::TreeNode::Argument
        expect(subject.sections[1].properties[0].value.arguments[0].value).to eq 0
        expect(subject.sections[1].properties[0].value.arguments[1].value).to eq 0.44705883
        expect(subject.sections[1].properties[0].value.arguments[2].value).to eq 0.23921569
        expect(subject.sections[1].properties[0].value.arguments[3].value).to eq 1
      end
    end
  end
end

