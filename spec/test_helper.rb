module TestHelper
  def demo_for(name)
    allow(GdDoc.config).to receive(:project_dir).and_return("demo/#{name}")
  end
end
