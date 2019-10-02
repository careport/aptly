RSpec.describe Aptly::DatabaseImage do
  describe "#id" do
    it "is the id from the JSON data" do
      image = Aptly::DatabaseImage.new(nil, image_data)
      expect(image.id).to eq(1)
    end
  end

  describe "#type" do
    it "is the type from the JSON data" do
      image = Aptly::DatabaseImage.new(nil, image_data)
      expect(image.type).to eq("postgresql")
    end
  end

  describe "#version" do
    it "is the version from the JSON data" do
      image = Aptly::DatabaseImage.new(nil, image_data)
      expect(image.version).to eq("11")
    end
  end

  describe "#description" do
    it "is the description from the JSON data" do
      image = Aptly::DatabaseImage.new(nil, image_data)
      expect(image.description).to eq("PostgreSQL 11")
    end
  end

  def image_data
    JsonFixtures.database_images.first
  end
end
