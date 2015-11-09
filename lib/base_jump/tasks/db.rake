require 'fileutils'

module BaseJumpRakeTasks
  module DB
    extend self

    def create(env = nil)
      load_environment env
      FileUtils.mkdir_p db_dir unless File.directory?(db_dir)
      FileUtils.touch File.join(lib_path, config['database'])
    end

    def drop(env = nil)
      load_environment env
      path = File.join(lib_path, config['database'])
      FileUtils.rm path if File.file?(path)
    end

    def migrate(env = nil)
      load_environment env

      app.database_connect! config

      ActiveRecord::Migration.verbose = true

      ActiveRecord::Migrator.migrate Migration.base_path

      schema_dump
    end

    def schema_dump
      load_environment

      schema_file = File.expand_path('db/schema.rb')

      File.open(schema_file, 'w:utf-8') do |file|
        ActiveRecord::SchemaDumper.dump ActiveRecord::Base.connection, file
      end
    end

    def rollback
      load_environment

      app.database_connect! config

      ActiveRecord::Migrator.rollback Migration.base_path, 1

      schema_dump
    end

    def prepare_test
      load_environment :test

      drop :test
      create :test
      migrate :test
    end

    private

    def db
      config['database']
    end

    def db_dir
      File.dirname db
    end

    def config
      @config
    end

    def lib_path
      @lib_path ||= File.expand_path(Dir.pwd)
    end

    def lib
      @lib ||= File.basename(lib_path)
    end

    def app
      return @app if defined?(@app)

      require File.join(lib_path, 'lib', lib)
      @app = Kernel.const_get(lib.camelcase)
    end

    def load_environment(env = nil)
      app.logger.level = Logger::INFO
      @config = app.database_config(env)
      driver = @config['adapter']

      unless drivers.include?(driver)
        msg = "#{BaseJump} does not support the chosen driver (#{driver}). "
        msg += "Supported drivers are: #{drivers}."
        raise ArgumentError.new(msg)
      end
    end

    def drivers
      [
        'sqlite3',
      ]
    end
  end

  module Migration
    extend self

    def create
      FileUtils.mkdir_p base_path unless File.directory?(base_path)
      if migration_name && !migration_name.strip.empty?
        File.write migration_path, content
      else
        puts 'A migration name was not specified.'
        puts 'Run this command with NAME specified.'
        puts 'NAME=[my_migration_name] bundle exec rake db:migration'
      end
    end

    def base_path
      'db/migrate/'
    end

    private

    def content
      text = "class #{class_name} < ActiveRecord::Migration\n"
      text += "  def change\n"
      text += "  end\n"
      text += "end\n"
    end

    def class_name
      migration_name.split('_').map do |word|
        word.capitalize
      end.join
    end

    def migration_path
      File.join base_path, file_name
    end

    def file_name
      "#{timestamp}_#{migration_name}.rb"
    end

    def migration_name
      @migration_name ||= ENV['NAME']
    end

    def timestamp
      @timestamp ||= Time.now.strftime('%Y%m%d%H%M%S')
    end
  end
end

namespace :db do
  desc 'Creates a database'
  task :create do
    BaseJumpRakeTasks::DB.create
  end

  desc 'Drop a database'
  task :drop do
    BaseJumpRakeTasks::DB.drop
  end

  desc 'Run migrations'
  task :migrate do
    BaseJumpRakeTasks::DB.migrate
  end

  desc 'Create a new migration (NAME=migration_name (required))'
  task 'migration:create' do
    BaseJumpRakeTasks::Migration.create
  end

  desc 'Rollback migrations'
  task :rollback do
    BaseJumpRakeTasks::DB.rollback
  end

  desc 'dump the schema'
  task 'schema:dump' do
    BaseJumpRakeTasks::DB.schema_dump
  end

  desc 'Prepare the test database'
  task 'test:prepare' do
    BaseJumpRakeTasks::DB.prepare_test
  end

  desc 'Set up a new database'
  task :setup => [:create, :migrate, 'db:test:prepare']
end
