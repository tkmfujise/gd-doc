require 'spec_helper'

RSpec.describe GdDoc::Project do
  describe '.files' do
    subject { GdDoc::Project.files }
    it { is_expected.to be_a(Array) }
  end


  describe '.parser' do
    subject { GdDoc::Project.parser }
    it { is_expected.to be_a(TreeStand::Parser) }
  end


  describe '#initialize' do
    subject { GdDoc::Project.new(file) }

    context 'demo file' do
      let(:file) { GdDoc::Project.files[0] }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.path).to eq 'res://project.godot'
      end
    end
  end


  describe '#parse' do
    subject { GdDoc::Project.new(file) }
    let(:file) { Tempfile.new.tap{|f| File.write f, src } }

    context 'plain' do
      let(:src) {
        <<~TSCN
          ; Engine configuration files

          config_version=5

          [application]

          config/name = "GdDoc Demo"
        TSCN
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.properties[0]).to be_a GdDoc::Property
        expect(subject.properties[0].name).to eq 'config_version'
        expect(subject.properties[0].value).to eq 5

        expect(subject.sections[0]).to be_a GdDoc::Section
        expect(subject.sections[0].name).to eq 'application'
        expect(subject.sections[0].properties[0]).to be_a GdDoc::Property
        expect(subject.sections[0].properties[0].name).to eq 'config/name'
        expect(subject.sections[0].properties[0].value).to eq 'GdDoc Demo'
      end
    end
  end
end

