namespace :db do
  desc "Loads test seed data."
  task :test_seed => :environment do |t|

    Settings.delete_all

    Settings.create(key: "import_user", value: "greg")
    Settings.create(key: "source_path", value: "/Volumes/Big/tmp/music")
    Settings.create(key: "dest_path", value: "/Volumes/Big/TuneZombie/Music")
    Settings.create(key: "itunes_xml_path", value: "/Volumes/Big/tmp/iml.xml")

  end
end