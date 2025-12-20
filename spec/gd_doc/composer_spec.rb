require 'spec_helper'

RSpec.describe GdDoc::Composer do
  describe '#initialize' do
    subject { GdDoc::Composer.new }
    it 'works' do
      expect{ subject }.not_to raise_error
      expect(subject.project).to be_a GdDoc::Project
      expect(subject.resources[0]).to be_a GdDoc::Resource
      expect(subject.scenes[0]).to be_a GdDoc::Scene
      expect(subject.scenes[0]).to be_a GdDoc::Scene
      expect(subject.scripts[0]).to be_a GdDoc::Script
      expect(subject.scenes.map(&:script).compact[0]).to be_a GdDoc::Script
    end
  end
end
