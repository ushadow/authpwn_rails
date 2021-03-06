require 'active_model'
require 'active_support'

# :nodoc: namespace
module Authpwn

# :nodoc: namespace
module UserExtensions
  
# Augments the User model with an email virtual attribute.
module EmailField
  extend ActiveSupport::Concern
  
  included do
    validates :email, :format => /^[A-Za-z0-9.+_]+@[^@]*\.(\w+)$/,
         :presence => true
    attr_accessible :email
  end
  
  module ClassMethods
    # The user who has a certain e-mail, or nil if the e-mail is unclaimed.
    def with_email(email)
      credential = Credentials::Email.where(:name => email).includes(:user).first
      credential && credential.user
    end
  end
  
  # Credentials::Email instance associated with this user.
  def email_credential
    credentials.find { |c| c.instance_of?(Credentials::Email) }
  end
  
  # The e-mail from the user's Email credential.
  #
  # Returns nil if this user has no Email credential.
  def email
    credential = self.email_credential
    credential && credential.email
  end
  
  # Sets the e-mail on the user's Email credential.
  #
  # Creates a new Credentials::Email instance if necessary.
  def email=(new_email)
    if credential = self.email_credential
      credential.email = new_email
    else
      credentials << Credentials::Email.new(:email => new_email)
    end
    new_email
  end
end  # module Authpwn::UserExtensions::EmailField
  
end  # module Authpwn::UserExtensions
  
end  # module Authpwn
