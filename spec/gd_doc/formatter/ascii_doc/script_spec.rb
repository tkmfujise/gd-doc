require 'spec_helper'

RSpec.describe GdDoc::Formatter::AsciiDoc::Script do
  describe '#initialze' do
    subject { described_class.new(script) }
    let(:script) { GdDoc::Script.new(file) }
    let(:file) { Tempfile.new.tap{|f| File.write f, src } }

    context 'basic' do
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
        expect{ subject.format }.not_to raise_error
      end
    end
  end
end


