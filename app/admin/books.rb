ActiveAdmin.register Book do
  includes :shelve, :author, :categories, :translations
  permit_params :name, :author_id, :shelve_id, category_ids: []

  filter :categories_id, as: :check_boxes, collection: -> {
    Category.includes(:translations).all.map { |c| [c.name, c.id] }
  }, multiple: true

  show do
    attributes_table do
      row :id, book.id
      row :name, book.name
      row :borrowed_at, book.borrowed_at
      row :created_at, book.created_at_formated
    end
  end

  sidebar "Shelve", only: :show do
    attributes_table_for book.shelve do
      row :name
      row :max_amount
    end
  end

  index do
    selectable_column
    id_column
    column :name, sortable: :name
    column :author
    column('Available?') { |b| status_tag b.is_available }
    actions
  end

  form title: 'Add New Book' do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :author
      f.input :shelve
      f.input :name
      f.input :categories, as: :check_boxes, input_html: { multiple: true }, collection: Category.all.map { |c| [c.name, c.id] }, selected: f.object.category_ids
    end
    # f.inputs :author, :shelve, :name
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end

end
