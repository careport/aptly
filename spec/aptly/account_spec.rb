RSpec.describe Aptly::Account do
  describe "#id" do
    it "is the id from the JSON data" do
      account = Aptly::Account.new(nil, account_data)
      expect(account.id).to eq(2)
    end
  end

  describe "#handle" do
    it "is the handle from the JSON data" do
      account = Aptly::Account.new(nil, account_data)
      expect(account.handle).to eq("prod")
    end
  end

  describe "#apps_href" do
    it "is the apps href from the JSON data" do
      account = Aptly::Account.new(nil, account_data)
      expect(account.apps_href).to eq("https://example.com/accounts/2/apps")
    end
  end

  def account_data
    JsonFixtures.accounts.last
  end
end
