# frozen_string_literal: true

class AwsConfig < ApplicationConfig
  attr_config :access_key_id, :secret_access_key, :region, :storage_bucket

  def storage_configured?
    access_key_id.present? &&
      secret_access_key.present? &&
      storage_bucket.present?
  end
end
