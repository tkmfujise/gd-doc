require 'spec_helper'

RSpec.describe GdDoc::Composer do
  describe '#initialize' do
    subject { GdDoc::Composer.new }
    it 'works' do
      expect{ subject }.not_to raise_error
      expect(subject.project).to be_a GdDoc::Project
      expect(subject.resources[0]).to be_a GdDoc::Resource
      expect(subject.scripts).to be_a Hash
      expect(subject.scripts.keys[0]).to start_with 'res://'
      expect(subject.scripts.values[0]).to be_a GdDoc::Script
      expect(subject.resources.map(&:script).compact[0]).to be_a GdDoc::Script
    end
  end
end
