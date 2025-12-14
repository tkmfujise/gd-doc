require 'spec_helper'

RSpec.describe GdDoc do
  describe '.config' do
    subject { GdDoc.config }
    it { expect{ subject }.not_to raise_error }
  end
end
