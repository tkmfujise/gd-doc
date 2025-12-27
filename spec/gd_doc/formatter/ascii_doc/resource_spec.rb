require 'spec_helper'

RSpec.describe GdDoc::Formatter::AsciiDoc::Resource do
  describe '#initialze' do
    subject { described_class.new(resource) }
    let(:resource) { GdDoc::Resource.new(file) }
    let(:file) { Tempfile.new.tap{|f| File.write f, src } }

    context 'basic' do
      let(:src) {
        <<~TSCN
          [gd_resource load_steps=34 format=3 uid="uid://foobar"]

          [sub_resource type="StyleBoxFlat" id="StyleBoxFlat_ht2pf"]
          bg_color = Color(0, 0.44705883, 0.23921569, 1)
        TSCN
      }

      it 'works' do
        expect{ subject }.not_to raise_error
        expect{ subject.format }.not_to raise_error
      end
    end
  end
end



