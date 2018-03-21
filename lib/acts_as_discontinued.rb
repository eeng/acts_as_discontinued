require "acts_as_discontinued/version"
require "acts_as_discontinued/acts_as_discontinued"
ActiveRecord::Base.class_eval { include ActsAsDiscontinued }