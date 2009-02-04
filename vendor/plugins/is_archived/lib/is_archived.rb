module Howcast
  module Acts
    module Archived
      def self.included(base)
        base.extend ActMacro
      end
      
      # Specify this act if you want to move this row to an archived table.  This assumes there is a 
      # archive table ready with the association id. (archiving a video will assume there is a video_id column
      # in the video_archives table)
      #
      # The class for the archived model is derived the first time it is seen. Therefore, if you change your 
      # database schema you have to restart your container for the changes to be reflected. 
      # In development mode this usually means restarting WEBrick.
      #
      #   class Video < ActiveRecord::Base
      #     is_archived
      #   end
      #
      # Example:
      #
      #   video = Video.create(:title => 'hello world!')
      #   video.archive!
      #   
      #   Video.count
      #   => 0
      #   Video::Archive.count
      #   => 1
      #
      #   Video::Archive.first.unarchive!
      #
      #   Video.count
      #   => 1
      #   Video::Archive.count
      #   => 0
      module ActMacro
        # Acts_as_versioned comes prepared with the Howcast::Acts::Archived::ClassMethods#create_archive_table 
        # method, perfect for a migration.
        #
        #   class AddArchive < ActiveRecord::Migration
        #     def self.up
        #       # create_archive_table takes the same options hash
        #       # that create_table does
        #       Video.create_archive_table
        #     end
        # 
        #     def self.down
        #       Video.drop_archive_table
        #     end
        #   end
        #
        # Options include:
        # * <tt>table_name</tt> - archived model table name (default: video_archives in the above example)
        # * <tt>class_name</tt> - archived model class name (default: VideoArchive in the above example)
        # * <tt>sequence_name</tt> - name of the custom sequence to be used by the archive model.        
        # * <tt>inheritance_column</tt> - name of the column to save the model's inheritance_column value for STI.  (default: archived_type)
        # * <tt>extend</tt> - Lets you specify a module to be mixed in both the original and archive models.  You can also just pass a block
        #
        #   to create an anonymous mixin:
        #
        #     class Video
        #       is_archived do
        #         def started?
        #           !started_at.nil?
        #         end
        #       end
        #     end
        #
        #   or...
        #
        #     module VideoArchiveExtension
        #       def started?
        #         !started_at.nil?
        #       end
        #     end
        #     class Video
        #       is_archived :extend => VideoArchiveExtension
        #     end
        def is_archived(options={}, &extension)
          cattr_accessor :archive_class_name, :archive_table_name, :archive_foreign_key, :archive_inheritance_column
          self.archive_table_name = options[:table_name] || "#{base_class.name.demodulize.underscore}_archives"
          self.archive_class_name = options[:class_name] || "Archive"
          self.archive_foreign_key = options[:foreign_key] || base_class.to_s.foreign_key
          self.archive_inheritance_column = options[:inheritance_column] || "archived_#{inheritance_column}"
          
          self.extend(ClassMethods)
          self.send(:include, Howcast::Acts::Archived::InstanceMethods)
          
          if block_given?
            extension_module_name = "#{archive_class_name}ArchiveExtension"
            silence_warnings do
              self.const_set(extension_module_name, Module.new(&extension))
            end

            options[:extend] = self.const_get(extension_module_name)
          end
          
          # create the dynamic archive model
          const_set(archive_class_name, Class.new(ActiveRecord::Base)).class_eval do
            self.inheritance_column = nil
            belongs_to :archiver, :class_name => "User", :foreign_key => "archiver_id"
            
            # Deletes the archived record and reinserts it exactly how it was in the original table
            def unarchive!
              o = original_class.new
              original_class.archived_columns.each do |c|
                if c.type == :datetime && !self.send(c.name).nil?
                  value = self.send(c.name).strftime("%Y-%m-%d %H:%M:%S")
                else
                  value = self.send(c.name)
                end
                o.send("#{c.name}=", value)
              end
              o.save(false)
              original_class.update_all("id = #{self.send(archive_foreign_key)}", "id = #{o.id}")
              self.destroy
            end
          end
          archive_class.cattr_accessor :original_class
          archive_class.original_class = self
          archive_class.cattr_accessor :archive_foreign_key
          archive_class.archive_foreign_key = archive_foreign_key
          archive_class.set_table_name archive_table_name
          archive_class.belongs_to self.to_s.demodulize.underscore.to_sym, 
            :class_name  => "::#{self.to_s}", 
            :foreign_key => archive_foreign_key
          archive_class.send :include, options[:extend] if options[:extend].is_a?(Module)
        end
      end
      
      module InstanceMethods
        attr_accessor :archiver_id
        def archive!
          new_model = self.class.archive_class.new
          self.class.archived_columns.each do |col|
            new_model.send("#{col.name}=", self.send(col.name)) if self.has_attribute?(col.name)
          end
          new_model.send("#{self.class.base_class.to_s.foreign_key}=", self.id)
          new_model.archiver_id = self.archiver_id
          new_model.save
          self.destroy
        end
      end

      module ClassMethods
        def archived_columns
          @archived_columns ||= columns.delete_if { |c| c.name == 'id' }
        end
        
        # Returns an instance of the dynamic archive model
        def archive_class
          const_get archive_class_name
        end
        
        def create_archive_table(create_table_options = {})
          self.connection.create_table(archive_table_name, create_table_options) do |t|
            t.column archive_foreign_key, :integer
            t.column :archiver_id, :integer
          end

          updated_col = nil
          self.archived_columns.each do |col| 
            updated_col = col if !updated_col && %(updated_at updated_on).include?(col.name)
            self.connection.add_column archive_table_name, col.name, col.type, 
              :limit     => col.limit, 
              :default   => col.default,
              :scale     => col.scale,
              :precision => col.precision
          end

          if type_col = self.columns_hash[inheritance_column]
            self.connection.add_column archive_table_name, archive_inheritance_column, type_col.type, 
              :limit     => type_col.limit, 
              :default   => type_col.default,
              :scale     => type_col.scale,
              :precision => type_col.precision
          end

          if updated_col.nil?
            self.connection.add_column archive_table_name, :updated_at, :timestamp
          end
        end
        
        def drop_archive_table
          self.connection.drop_table archive_table_name
        end
      end
    end
  end
end
