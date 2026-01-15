require 'spec_helper'

RSpec.describe GdDoc::Formatter::AsciiDoc::Project do
  describe '#initialze' do
    subject { described_class.new(composer) }
    let(:composer) { GdDoc::Composer.new }

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
        expect(subject.file_path.to_s).to eq File.join(GdDoc.config.doc_dir, 'content', 'index.adoc')
        expect{ subject.format }.not_to raise_error
      end
    end
  end
end
