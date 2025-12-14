require 'spec_helper'

RSpec.describe GdDoc::Resource do
  describe '.files' do
    subject { GdDoc::Resource.files }
    it { is_expected.to be_a(Array) }
  end


  describe '.parser' do
    subject { GdDoc::Resource.parser }
    it { is_expected.to be_a(TreeStand::Parser) }
  end


  describe '#initialize' do
    subject { GdDoc::Resource.new(file) }

    context 'demo file' do
      let(:file) { GdDoc::Resource.files[0] }
      it { expect{ subject }.not_to raise_error }
    end
  end
end


