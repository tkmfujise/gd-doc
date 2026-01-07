require 'spec_helper'

RSpec.describe GdDoc::Formatter::AsciiDoc::Asset::Image do
  describe '#initialze' do
    subject { described_class.new(image) }
    let(:image) { GdDoc::Asset::Image.build }

    context 'basic' do
      it 'works' do
        expect{ subject }.not_to raise_error
        expect{ subject.format }.not_to raise_error
        expect(subject.raw_path).not_to be_empty
        expect(subject.store_file_paths).to be_any
      end
    end
  end
end
