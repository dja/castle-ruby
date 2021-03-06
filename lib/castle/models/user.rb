module Castle
  class User < Model
    instance_post :enable_mfa!
    instance_post :disable_mfa!

    has_many :challenges
    has_many :events
    has_many :pairings
    has_many :sessions
    has_many :trusted_devices

    def backup_codes(params={})
      Castle::BackupCodes.get("/v1/users/#{id}/backup_codes", params)
    end

    def generate_backup_codes(params={})
      Castle::BackupCodes.post("/v1/users/#{id}/backup_codes", params)
    end
  end
end
