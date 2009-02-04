# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_supportr_session',
  :secret      => '0c53b727e3e9f1a1abfa16c48c7006ae13c181fca5b5b1db2a5f9fbb5085f83f82d60cd6dcd4e35be017b3e97275b4dfce668bf00deac64185f451b9f0dd6ef2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
