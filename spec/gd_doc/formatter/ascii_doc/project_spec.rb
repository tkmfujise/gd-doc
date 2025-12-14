require 'spec_helper'

RSpec.describe GdDoc::Formatter::AsciiDoc::Project do
  describe '#initialze' do
    subject { described_class.new(project) }
    let(:project) { GdDoc::Project.new(file) }
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
        expect(subject.file_path).to eq File.join(GdDoc.config.doc_dir, 'index.adoc')
        expect{ subject.format }.not_to raise_error
      end
    end
  end
end
