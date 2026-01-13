require 'spec_helper'

RSpec.describe GdDoc::Asset::Image do
  describe '.files' do
    subject { GdDoc::Asset::Image.files }
    it { is_expected.to be_a(Array) }
  end


  describe '#initialize' do
    subject { GdDoc::Asset::Image.new(file) }

    context 'demo file' do
      let(:file) { GdDoc::Asset::Image.files[0] }
      it 'works' do
        expect{ subject }.not_to raise_error 
        expect(subject.path).to start_with 'res://'
      end
    end
  end


  describe 'Numeric#human_size' do
    subject { bytes.human_size }

    context 'if 0' do
      let(:bytes) { 0 }
      it { is_expected.to eq '0.0 B' }
    end

    context 'if 1.0' do
      let(:bytes) { 1.0 }
      it { is_expected.to eq '1.0 B' }
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
