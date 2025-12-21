
desc 'Update *adoc files and compile, then run server'
task :default => %i[update compile server]


desc 'Update *.adoc files'
task :update do
  sh 'gd-doc update'
end


desc 'Compile *.adoc files to *.html'
task :compile do
  sh 'bundle exec nanoc'
end
desc 'Alias for `rake compile`'
task :c => :compile


desc 'Run server'
task :server do
  sh 'bundle exec nanoc view --host 0.0.0.0 --port 3001'
end
desc 'Alias for `rake server`'
task :s => :server


desc 'Run live reloading server and watch files'
task :watch do
  # WARNING: Not working on WSL
  trap :INT do
    pid = `pgrep -u #{Process.uid} -f puma`
    Process.kill(:TERM, pid.to_i) if pid
    exit
  end
  sh 'bundle exec nanoc live --host 0.0.0.0 --port 3001'
end
desc 'Alias for `rake watch`'
task :w => :watch
