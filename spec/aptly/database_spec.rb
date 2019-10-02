RSpec.describe Aptly::Database do
  describe "#id" do
    it "is the id from the JSON data" do
      db = Aptly::Database.new(nil, db_data)
      expect(db.id).to eq(1)
    end
  end

  describe "#handle" do
    it "is the handle from the JSON data" do
      db = Aptly::Database.new(nil, db_data)
      expect(db.handle).to eq("my-db")
    end
  end

  describe "#type" do
    it "is the type from the JSON data" do
      db = Aptly::Database.new(nil, db_data)
      expect(db.type).to eq("postgresql")
    end
  end

  describe "#passphrase" do
    it "is the passphrase from the JSON data" do
      db = Aptly::Database.new(nil, db_data)
      expect(db.passphrase).to eq("opensesame")
    end
  end

  describe "#connection_url" do
    it "is the connection URL from the JSON data" do
      db = Aptly::Database.new(nil, db_data)
      expect(db.connection_url).
        to eq("postgresql://aptible:opensesame@db-foobar-1234.aptible.in:20807/db")
    end
  end

  describe "#status" do
    it "is the status from the JSON data" do
      db = Aptly::Database.new(nil, db_data)
      expect(db.status).to eq("provisioned")
    end
  end

  describe "#operations_href" do
    it "is the URL of this database's operations collection" do
      db = Aptly::Database.new(nil, db_data)
      expect(db.operations_href).
        to eq("https://example.com/databases/1/operations")
    end
  end

  describe "#provisioned?" do
    it "is true just in case status == 'provisioned'" do
      provisioned_db = Aptly::Database.new(nil, db_data)
      unprovisioned_db = Aptly::Database.new(nil, db_data.merge("status" => "blah"))
      expect(provisioned_db).to be_provisioned
      expect(unprovisioned_db).not_to be_provisioned
    end
  end

  def db_data
    JsonFixtures.databases.first
  end
end
