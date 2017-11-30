require 'sequel/extensions/migration'

module SequelRails
  class Migrations
    class << self
      def migrate(version = nil)
        opts = {}
        opts[:target] = version.to_i if version
        ::Sequel::Migrator.run(::Sequel::Model.db, migrations_dir, opts)
      end
      alias_method :migrate_up!, :migrate
      alias_method :migrate_down!, :migrate

      def pending_migrations?
        return false unless available_migrations?
        !::Sequel::Migrator.is_current?(::Sequel::Model.db, migrations_dir)
      end

      def dump_schema_information(opts = {})
        sql = opts.fetch :sql
        adapter = SequelRails::Storage.adapter_for(Rails.env)
        db = ::Sequel::Model.db
        res = ''

        if available_migrations?
          migrator_class = ::Sequel::Migrator.send(:migrator_class, migrations_dir)
          migrator = migrator_class.new db, migrations_dir
          res << adapter.schema_information_dump(migrator, sql)
        end
        res
      end

      def migrations_dir
        Rails.root.join('db/migrate')
      end

      def current_migration
        return unless available_migrations?

        migrator_class = ::Sequel::Migrator.send(:migrator_class, migrations_dir)
        migrator = migrator_class.new ::Sequel::Model.db, migrations_dir
        if migrator.respond_to?(:applied_migrations)
          migrator.applied_migrations.last
        elsif migrator.respond_to?(:current_version)
          migrator.current_version
        end
      end

      def previous_migration
        return unless available_migrations?

        migrator_class = ::Sequel::Migrator.send(:migrator_class, migrations_dir)
        migrator = migrator_class.new ::Sequel::Model.db, migrations_dir
        if migrator.respond_to?(:applied_migrations)
          migrator.applied_migrations[-2] || '0'
        elsif migrator.respond_to?(:current_version)
          migrator.current_version - 1
        end
      end

      def available_migrations?
        File.exist?(migrations_dir) && Dir[File.join(migrations_dir, '*')].any?
      end

      def copy(destination, sources, options = {})
        copied = []

        FileUtils.mkdir_p(destination) unless File.exist?(destination)

        destination_migrations = Dir["#{destination}/*.rb"]
        last = destination_migrations.last
        sources.each do |scope, path|
          source_migrations = Dir["#{path}/*.rb"]

          source_migrations.each do |migration|
            source = File.binread(migration)
            inserted_comment = "# This migration comes from #{scope} (originally #{File.basename(migration)})\n"
            if /\A#.*\b(?:en)?coding:\s*\S+/ =~ source
              # If we have a magic comment in the original migration,
              # insert our comment after the first newline(end of the magic comment line)
              # so the magic keep working.
              # Note that magic comments must be at the first line(except sh-bang).
              source[/\n/] = "\n#{inserted_comment}"
            else
              source = "#{inserted_comment}#{source}"
            end

            if duplicate = destination_migrations.detect { |m| File.basename(m) == File.basename(migration) }
              if options[:on_skip] && duplicate.scope != scope.to_s
                options[:on_skip].call(scope, migration)
              end
              next
            end

            new_path = File.join(destination, File.basename(migration))
            old_path = migration
            last = migration

            File.binwrite(new_path, source)
            copied << migration
            options[:on_copy].call(scope, migration, old_path) if options[:on_copy]
            destination_migrations << migration
          end
        end

        copied
      end
    end
  end
end
