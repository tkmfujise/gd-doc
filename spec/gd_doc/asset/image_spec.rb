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
end
