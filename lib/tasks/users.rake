# frozen_string_literal: true

namespace :users do
  desc 'Set all existing users to active'
  task save: :environment do
    User.all.map(&:save!)
  end

  desc 'Configure MFA for all existing users'
  task configure_mfa: :environment do
    p 'Generating TOTP secret for existing users...'
    User.all.each do |user|
      user.otp_secret_key = user.generate_totp_secret
      user.save!
    end
    p 'Complete'
  end
end
