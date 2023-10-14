ActiveAdmin.register User do
  permit_params :name, :email, :password_digest, :email_verified_at
end
