require 'spec_helper'


RSpec.describe GDDoc do
  describe '.parse' do
    subject { GDDoc.parse }
    it { expect{ subject }.not_to raise_error }
  end
end
