# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
#
# thanks to:
# https://github.com/jeremyw/voter-registration/commit/2fa8796658fdbf18490cd2a3d7bf173e53b1cab8
if Rails.env.production? && ENV['SECRET_TOKEN'].blank? && ENV['RAILS_GROUPS'] != 'assets'
	raise 'SECRET_TOKEN environment variable must be set!'
end

Musicrecommendation::Application.config.secret_token = ENV['SECRET_TOKEN'] || '660ccf41cd6026b37cc63c57bc0da3f15426ae3acd2472d37abaf51a4e0ab756a1d59c4261f882c6c2ee9b11d6ddb1e8ef3ade8041a5825374aebdab5da9ddaf'
