module GdDoc::Commands
  module Helper
    def load_config_file
      file = File.join(Dir.pwd, 'config.rb')
      if File.exist?(file)
        load file 
      else
        GdDoc.config.doc_dir = '.'
      end
    end


    %i[
      mkdir_p
      cp
      cp_r
      rm_r
    ].each do |method_name|
      define_method(method_name) do |*args, **kwargs|
        FileUtils.public_send(method_name,
          *args, **kwargs.merge(verbose: GdDoc.config.log_verbose))
      end
    end

    def write(path, content)
      puts "write #{path}"
      File.write(path, content)
    end


    def sh(command)
      puts "sh #{command}"
      system(command)
    end


    def yes?(message)
      print "#{message} (y/N): "
      unless %w[y yes Y].include?(STDIN.gets.chomp)
        STDERR.puts 'Confirmation failed.'
        exit
      end
    end


    def templates_dir
      File.join(GdDoc::ROOT_DIR, 'templates')
    end
  end
end

