ActiveAdmin.register Tag do
  permit_params :name, :description, card_ids: []
  form html: { multipart: true } do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :cards, as: :select, collection: Card.where(is_maverick: false).all, prompt: "Choose cards"
    end
    f.actions
  end
end
