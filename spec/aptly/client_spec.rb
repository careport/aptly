RSpec.describe Aptly::Client do
  describe "#access_token" do
    context "with valid credentials" do
      it "is an OAuth2::AccessToken" do
        email = "foo@example.com"
        password = "password"

        stub_valid_token_request(email, password)

        client = Aptly::Client.new(email, password)
        token = client.access_token
        expect(token).to be_a(OAuth2::AccessToken)
      end
    end

    context "with invalid credentials" do
      it "raises OAuth2::Error" do
        email = "foo@example.com"
        password = "bad_password"

        stub_invalid_token_request(email, password)

        client = Aptly::Client.new(email, password)
        expect { client.access_token }.to raise_error(OAuth2::Error)
      end
    end
  end

  describe "#apps" do
    it "is an array of Aptly::Apps" do
      test_collection("apps", Aptly::App, JsonFixtures.apps)
    end
  end

  describe "#find_app" do
    context "with a valid app_id" do
      it "is an Aptly::App" do
        test_find("app", Aptly::App, JsonFixtures.apps.first)
      end
    end

    context "with an invalid app_id" do
      it "raises OAuth2Error" do
        email = "foo@example.com"
        password = "password"
        app_id = 123

        stub_valid_token_request(email, password)
        stub_invalid_app_request(app_id)

        client = Aptly::Client.new("foo@example.com", "password")
        expect { client.find_app(app_id) }.to raise_error(OAuth2::Error)
      end
    end
  end

  describe "#database_images" do
    it "is an array of Aptly::DatabaseImages" do
      test_collection(
        "database_images",
        Aptly::DatabaseImage,
        JsonFixtures.database_images
      )
    end
  end

  describe "#find_database_image" do
    it "is an Aptly::DatabaseImage" do
      test_find(
        "database_image",
        Aptly::DatabaseImage,
        JsonFixtures.database_images.first
      )
    end
  end

  describe "#databases" do
    it "is an array of Aptly::Databases" do
      test_collection("databases", Aptly::Database, JsonFixtures.databases)
    end
  end

  describe "#find_database" do
    it "is an Aptly::Database" do
      test_find("database", Aptly::Database, JsonFixtures.databases.first)
    end
  end

  describe "#accounts" do
    it "is an array of Aptly::Accounts" do
      test_collection("accounts", Aptly::Account, JsonFixtures.accounts)
    end
  end

  describe "#find_account" do
    it "is an Aptly::Acount" do
      test_find("account", Aptly::Account, JsonFixtures.accounts.first)
    end
  end

  def test_find(resource_name, resource_class, resource_data)
    email = "foo@example.com"
    password = "password"
    id = resource_data["id"]

    stub_valid_token_request(email, password)
    stub_valid_resource_request(id, resource_name, resource_data)

    client = Aptly::Client.new(email, password)
    resource = client.public_send("find_#{resource_name}".to_sym, id)

    expect(resource).to be_a(resource_class)
    expect(resource.id).to eq(id)
  end

  def test_collection(collection_name, resource_class, collection_data)
    email = "foo@example.com"
    password = "password"

    stub_valid_token_request(email, password)
    stub_valid_collection_request(collection_name, collection_data)

    client = Aptly::Client.new(email, password)
    collection = client.public_send(collection_name.to_sym)

    expect(collection).to be_a(Array)
    expect(collection).to all be_a(resource_class)
  end
end
