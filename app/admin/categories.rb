ActiveAdmin.register Category do
  includes :books , :translations

  permit_params :name
end
