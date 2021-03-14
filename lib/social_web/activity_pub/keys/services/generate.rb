# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Keys
      class Generate
        def self.call(obj)
          keypair = OpenSSL::PKey::RSA.new(2048)

          keys.insert(
            object_id: obj[:id],
            private: keypair.to_pem,
            public: keypair.public_key.to_pem,
            created_at: Time.now.utc,
            updated_at: Time.now.utc
          )
        end
      end
    end
  end
end
