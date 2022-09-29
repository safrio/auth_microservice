namespace :db do
  desc 'Add database seeds'
  task :seed, :settings do
    require 'sequel'
    require 'sequel/extensions/seed'
    require_relative '../../config/environment'

    Sequel.extension :seed
    Sequel::Seed.setup :development

    Sequel.connect(Settings.db.to_hash) do |db|
      seeds = File.expand_path('db/seeds')
      Sequel::Seeder.apply(db, seeds)
    end
  end
end
