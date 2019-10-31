ActiveAdmin.register Card do
  permit_params :text, :artist, :a_house_id, :house_id, :expansion_id, :a_house, :expansion, :uuid, :title, :card_type, :front_image, :traits, :amber, :power, :armor, :rarity, :flavor_text, :number, :a_weight, :b_weight, :c_weight, :e_weight, :board_efficiency_weight, :hate_efficiency_weight, :card_efficiency_weight, tag_ids: []
  config.sort_order = 'number_asc'
  scope :no_mavericks, default: true
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  filter :title
  filter :number
  filter :description
  filter :expansion

  index do
    id_column
    column :title
    column :number
    column :faqs do |c|
      link_to c.faqs.count, admin_card_faqs_path(c)
    end
    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    tabs do
      tab "Base" do
        f.inputs          # builds an input field for every attribute
      end
      tab "Tags" do
        f.inputs do "Tags"
          f.input :tags, as: :select, collection: Tag.all
        end
      end
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  show do
    attributes_table(*resource.attributes.keys) do
      row "Tags" do |c|
        c.tags.collect{|x| x.name}.join(", ")
      end
    end
  end
end
