ActiveAdmin.register Shelve do
  includes :books

  permit_params :name, :max_amount

  show do
    attributes_table do
      row :id , shelve.id
      row :name , shelve.name
      row  :max_amount , shelve.max_amount.to_s
      row :created_at , shelve.created_at_formated
    end

    panel "Books" do
      table_for shelve.books do
        column :name
        column('Available?') { |b| status_tag b.is_available }
      end
    end
  end
  
end
