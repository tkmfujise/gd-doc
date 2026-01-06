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


  describe '#byte_size' do
    subject { formatter.send(:byte_size, bytes) }
    let(:formatter) { described_class.new(image) }
    let(:image) { GdDoc::Asset::Image.build }

    context 'if 0' do
      let(:bytes) { 0 }
      it { is_expected.to eq '0.0 B' }
    end

    context 'if 100' do
      let(:bytes) { 100 }
      it { is_expected.to eq '100.0 B' }
    end

    context 'if 1024' do
      let(:bytes) { 1024 }
      it { is_expected.to eq '1.0 KB' }
    end

    context 'if 100_000' do
      let(:bytes) { 100_000 }
      it { is_expected.to eq '97.66 KB' }
    end

    context 'if 1_000_000' do
      let(:bytes) { 1_000_000 }
      it { is_expected.to eq '976.56 KB' }
    end

    context 'if 2_000_000' do
      let(:bytes) { 2_000_000 }
      it { is_expected.to eq '1.91 MB' }
    end

    context 'if 2_000_000_000' do
      let(:bytes) { 2_000_000_000 }
      it { is_expected.to eq '1.86 GB' }
    end

    context 'if 2_000_000_000_000' do
      let(:bytes) { 2_000_000_000_000 }
      it { is_expected.to eq '1.82 TB' }
    end

    context 'if 2_000_000_000_000_000' do
      let(:bytes) { 2_000_000_000_000_000 }
      it { is_expected.to eq '1818.99 TB' }
    end
  end
end
