require 'spec_helper'

RSpec.describe GdDoc::Formatter::AsciiDoc do
  describe '#initialze' do
    subject { described_class.new(composer){|formatter| formatter.format } }
    let(:composer) { GdDoc::Composer.new }

    shared_examples 'works' do
      it 'works' do
        expect{ subject }.not_to raise_error
      end
    end


    context 'empty' do
      before { demo_for 'empty' }
      include_examples 'works'

      it 'has expected values' do
        expect(subject.project).not_to be_nil
        expect(subject.scenes).to be_empty
        expect(subject.scripts).to be_empty
        expect(subject.resources).to be_empty
        expect(subject.asset_images).to be_empty
      end
    end


    context 'simple' do
      before { demo_for 'simple' }
      include_examples 'works'

      it 'has expected values' do
        expect(subject.project).not_to be_nil
        expect(subject.project.project.main_scene).to be_nil
        expect(subject.scenes).to be_any
        expect(subject.scripts).to be_any
        expect(subject.resources).to be_empty
        expect(subject.asset_images).to be_any
      end
    end


    context 'complex' do
      before { demo_for 'complex' }
      include_examples 'works'
      it 'has expected values' do
        expect(subject.project).not_to be_nil
        expect(subject.project.project.main_scene).not_to be_nil
        expect(subject.scenes).to be_any
        expect(subject.scripts).to be_any
        expect(subject.resources).to be_any
        expect(subject.asset_images).to be_any
      end
    end
  end
end
