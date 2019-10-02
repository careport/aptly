module Aptly
  class Client
    class << self
      def def_collection(collection_name, member_class)
        define_method(collection_name.to_sym) do
          get_collection(collection_name, member_class)
        end

        define_method("find_#{collection_name.chop}".to_sym) do |id|
          find_collection_member(collection_name, member_class, id)
        end
      end
    end

    def_collection "accounts", Account
    def_collection "apps", App
    def_collection "database_images", DatabaseImage
    def_collection "databases", Database

    def initialize(email, password)
      @email = email
      @password = password
      @oauth_client = OAuth2::Client.new(nil, nil, oauth_options)
    end

    def access_token
      @access_token ||= @oauth_client.password.get_token(
        @email,
        @password,
        {
          scope: "manage"
        }
      )
    end

    private

    def get_collection(collection_name, member_class)
      hash = access_token.get("/#{collection_name}").parsed
      hash.dig("_embedded", collection_name).map do |data|
        member_class.new(access_token, data)
      end
    end

    def find_collection_member(collection_name, member_class, id)
      hash = access_token.get("/#{collection_name}/#{id}").parsed
      member_class.new(access_token, hash)
    end

    def oauth_options
      {
        site: ENV.fetch(
          "APTIBLE_SITE_URL",
          "https://api.aptible.com"
        ),
        token_url: ENV.fetch(
          "APTIBLE_TOKEN_URL",
          "https://auth.aptible.com/tokens"
        )
      }
    end
  end
end
