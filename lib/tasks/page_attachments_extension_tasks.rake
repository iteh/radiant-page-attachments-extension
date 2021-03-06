namespace :radiant do
  namespace :extensions do
    namespace :page_attachments do

      desc "Install the Page Attachments extension"
      task :install => [:environment, :migrate, :update]

      desc "Uninstall the Page Attachments extension"
      task :uninstall => :environment do
        require 'radiant/extension_migrator'
        PageAttachmentsExtension.migrator.migrate(0)
        asset_dirs = ["images", "javascripts", "stylesheets"]
        asset_dirs.each { |d| rm_r RAILS_ROOT + "/public/" + d + "/extensions/page_attachments" }
      end

      desc "Runs the migration of the Page Attachments extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          PageAttachmentsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          PageAttachmentsExtension.migrator.migrate
        end
      end

      desc "Copies public assets of the Page Attachments to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from PageAttachmentsExtension"
        Dir[PageAttachmentsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PageAttachmentsExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
        unless PageAttachmentsExtension.root.starts_with? RAILS_ROOT # don't need to copy vendored tasks
          puts "Copying rake tasks from PageAttachmentsExtension"
          local_tasks_path = File.join(RAILS_ROOT, %w(lib tasks))
          mkdir_p local_tasks_path, :verbose => false
          Dir[File.join PageAttachmentsExtension.root, %w(lib tasks *.rake)].each do |file|
            cp file, local_tasks_path, :verbose => false
          end
        end
      end  
    end
  end
end
