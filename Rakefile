require 'bundler/setup'

task :default => :server

task server: [:tree_sitter_build] do
  sh 'bin/server'
end


task :tree_sitter_build do
  cd 'tree-sitter-gdscript' do
    sh 'tree-sitter build'
  end
end
