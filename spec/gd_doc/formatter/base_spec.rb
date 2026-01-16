require 'spec_helper'

RSpec.describe GdDoc::Formatter::Base do
  let(:base) { described_class.new }

  describe 'overridable methods' do
    it 'raise error or empty' do
      expect{ base.file_name }.to raise_error(RuntimeError)
      expect{ base.format }.to raise_error(RuntimeError)
      expect(base.store_file_paths).to eq Hash.new
    end
  end
end
