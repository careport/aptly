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

  describe "#accounts" do
    it "is an array of Accounts" do
      email = "foo@example.com"
      password = "password"

      stub_valid_token_request(email, password)
      client = Aptly::Client.new(email, password)

      stub_valid_accounts_request
      accounts = client.accounts

      expect(accounts.length).to eq(2)
      expect(accounts).to all be_a(Aptly::Account)
    end
  end

  describe "#find_app" do
    context "with a valid app_id" do
      it "is an Aptible::App" do
        email = "foo@example.com"
        password = "password"
        app_id = 666

        stub_valid_token_request(email, password)
        stub_valid_app_request(app_id)

        client = Aptly::Client.new(email, password)
        app = client.find_app(app_id)
        expect(app).to be_a(Aptly::App)
        expect(app.id).to eq(app_id)
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
end
