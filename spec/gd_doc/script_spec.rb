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
    subject { GdDoc::Script.new(file) }
    let(:file) { Tempfile.new.tap{|f| File.write f, src } }

    context 'plain' do
      let(:src) {
        <<~GDSCRIPT
          extends Node
        GDSCRIPT
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.extends).to eq 'Node'
      end
    end

    context 'simple' do
      let(:src) {
        <<~GDSCRIPT
          extends Node
          class_name Foo
          static var foo = 1
          var bar : String = "Test"
          const Foo = true

          func _ready() -> void:
              pass

        GDSCRIPT
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.extends).to eq 'Node'
        expect(subject.class_name).to eq 'Foo'

        # functions
        expect(subject.functions[0]).to be_a(GdDoc::Function)
        expect(subject.functions[0].name).to eq '_ready'
        expect(subject.functions[0].parameters).to eq []
        expect(subject.functions[0].return_type).to eq 'void'

        # variables
        expect(subject.variables[0]).to be_a(GdDoc::Variable)
        expect(subject.variables[0].name).to eq 'foo'
        expect(subject.variables[0].type).to eq nil
        expect(subject.variables[0].static).to eq true
        expect(subject.variables[1].name).to eq 'bar'
        expect(subject.variables[1].type).to eq 'String'
        expect(subject.variables[1].static).to eq false

        # constants
        expect(subject.constants[0]).to be_a(GdDoc::Constant)
        expect(subject.constants[0].name).to eq 'Foo'
        expect(subject.constants[0].type).to eq nil
        expect(subject.constants[0].static).to eq false
      end
    end
  end
end

