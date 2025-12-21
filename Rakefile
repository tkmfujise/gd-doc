require 'bundler/setup'

task :default => :test


task :test do
  sh 'bundle exec rspec spec'
end


task build: [:tree_sitter_build] do
end


task :tree_sitter_build do
  targets = %w[
    tree-sitter-gdscript
    tree-sitter-godot-resource
  ]
  targets.each do |target|
    cd target do
      sh 'tree-sitter build'
    end
    Dir["#{target}/*"].select{|f| f =~ /\.(so|dylib)$/ }.each do |file|
      cp file, "tree-sitters/#{Pathname(file).basename}"
    end
  end
end

