module Aptly
  # This code is copied from OAuth2's master branch.
  # We should delete it when the next version of the
  # gem is released.
  OAuth2::Response.register_parser(:json, ['application/json', 'text/javascript', 'application/hal+json', 'application/vnd.collection+json', 'application/vnd.api+json']) do |body|
    MultiJson.load(body) rescue body # rubocop:disable RescueModifier
  end
end
