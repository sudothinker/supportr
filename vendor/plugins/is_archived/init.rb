require 'is_archived'

ActiveRecord::Base.class_eval do
  include Howcast::Acts::Archived
end
