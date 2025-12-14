require 'spec_helper'
require 'tempfile'

RSpec.describe GdDoc::Script do
  describe '.files' do
    subject { GdDoc::Script.files }
    it { is_expected.to be_a(Array) }
  end


  describe '.parser' do
    subject { GdDoc::Script.parser }
    it { is_expected.to be_a(TreeStand::Parser) }
  end


  describe '#initialize' do
    subject { GdDoc::Script.new(file) }

    context 'demo file' do
      let(:file) { GdDoc::Resource.files[0] }
      it { expect{ subject }.not_to raise_error }
    end
  end


  describe '#parse' do
    subject { record.parse }
    let(:record) { GdDoc::Script.new(file) }

    context 'simple' do
      let(:file) { Tempfile.new.tap{|f| File.write f, src } }
      let(:src) {
        <<~GDSCRIPT
          extends Node
        GDSCRIPT
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(record.extends).to eq 'Node'
      end
    end
  end
end

