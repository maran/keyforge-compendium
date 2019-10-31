ActiveAdmin.register Faq do
  permit_params :question, :answer, :card_id, :rule_id, :source_id, :rule_source_id
  belongs_to :card, optional: true

  form do |f|
    f.semantic_errors # shows errors on :base
    tabs do
      tab "Base" do
        f.inputs do
          f.input :card, as: :select, collection: Card.no_mavericks.order(title: :asc)
          f.input :rule, as: :select, collection: Rule.order(title: :asc)
          f.input :question
          f.input :answer
        end
      end
      tab "Sources" do
        f.inputs do
          f.input :rule_source, as: :select, collection: Rule.order(title: :asc)
          f.input :source, as: :select, collection: Source.order(name: :asc)
        end
      end
    end
    f.actions
  end

# See permitted parameters documentation:
  #
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

end
