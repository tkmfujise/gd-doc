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
      let(:file) { GdDoc::Script.files[0] }
      it 'works' do
        expect{ subject }.not_to raise_error 
        expect(subject.path).to start_with 'res://'
      end
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

          func foo(bar) -> String:
              return '%s!' % bar

          func _input(event: InputEvent):
              pass

        GDSCRIPT
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.extends).to eq 'Node'
        expect(subject.class_name).to eq 'Foo'

        # functions
        expect(subject.functions[0]).to be_a(GdDoc::TreeNode::Function)
        expect(subject.functions[0].name).to eq '_ready'
        expect(subject.functions[0].parameters).to eq []
        expect(subject.functions[0].return_type).to eq 'void'
        expect(subject.functions[0].overridden_virtual?).to eq true
        expect(subject.functions[0].text).not_to be_empty
        expect(subject.functions[1].name).to eq 'foo'
        expect(subject.functions[1].parameters[0]).to be_a(GdDoc::TreeNode::FunctionParameter)
        expect(subject.functions[1].parameters[0].name).to eq 'bar'
        expect(subject.functions[1].parameters[0].type).to eq nil
        expect(subject.functions[1].return_type).to eq 'String'
        expect(subject.functions[1].overridden_virtual?).to eq false
        expect(subject.functions[2].name).to eq '_input'
        expect(subject.functions[2].parameters[0].name).to eq 'event'
        expect(subject.functions[2].parameters[0].type).to eq 'InputEvent'
        expect(subject.functions[2].return_type).to eq nil
        expect(subject.functions[2].overridden_virtual?).to eq true

        # variables
        expect(subject.variables[0]).to be_a(GdDoc::TreeNode::Variable)
        expect(subject.variables[0].name).to eq 'foo'
        expect(subject.variables[0].type).to eq nil
        expect(subject.variables[0].static).to eq true
        expect(subject.variables[1].name).to eq 'bar'
        expect(subject.variables[1].type).to eq 'String'
        expect(subject.variables[1].static).to eq false

        # constants
        expect(subject.constants[0]).to be_a(GdDoc::TreeNode::Constant)
        expect(subject.constants[0].name).to eq 'Foo'
        expect(subject.constants[0].type).to eq nil
        expect(subject.constants[0].static).to eq false
      end
    end

    context 'signals' do
      let(:src) {
        <<~GDSCRIPT
          signal pressed
          signal changed(old_value, new_value)
        GDSCRIPT
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.signals[0]).to be_a GdDoc::TreeNode::Signal
        expect(subject.signals[0].name).to eq 'pressed'
        expect(subject.signals[1]).to be_a GdDoc::TreeNode::Signal
        expect(subject.signals[1].name).to eq 'changed'
        expect(subject.signals[1].parameters[0]).to be_a GdDoc::TreeNode::Parameter
        expect(subject.signals[1].parameters[0].name).to eq 'old_value'
        expect(subject.signals[1].parameters[1]).to be_a GdDoc::TreeNode::Parameter
        expect(subject.signals[1].parameters[1].name).to eq 'new_value'
      end
    end

    context '@onready / @export' do
      let(:src) {
        <<~GDSCRIPT
          @onready var foo = 1
          @export var bar : bool = false
        GDSCRIPT
      }
      it 'works' do
        expect{ subject }.not_to raise_error
        expect(subject.variables[0]).to be_a GdDoc::TreeNode::Variable
        expect(subject.variables[0].name).to eq 'foo'
        expect(subject.variables[0].annotations).to eq ['@onready']
        expect(subject.variables[1]).to be_a GdDoc::TreeNode::Variable
        expect(subject.variables[1].name).to eq 'bar'
        expect(subject.variables[1].annotations).to eq ['@export']
      end
    end
  end
end

