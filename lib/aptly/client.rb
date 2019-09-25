module Aptly
  class Client
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

    def accounts
      hash = access_token.get("/accounts").parsed
      hash.dig("_embedded", "accounts").map do |account_data|
        Account.new(access_token, account_data)
      end
    end

    def find_app(app_id)
      hash = access_token.get("/apps/#{app_id}").parsed
      App.new(access_token, hash)
    end

    private

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
