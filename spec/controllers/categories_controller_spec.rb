require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  describe "GET #show" do
    let(:category) { FactoryBot.create(:category) }

    context "when category exists" do
      it "returns a successful response" do
        get :show, params: { slug: category.slug }
        expect(response).to be_successful
      end

      it "assigns the requested category to @category" do
        get :show, params: { slug: category.slug }
        expect(assigns(:category)).to eq(category)
      end
    end

    context "when category does not exist" do
      it "redirects to the root path" do
        get :show, params: { slug: "non_existent_slug" }
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash danger message" do
        get :show, params: { slug: "non_existent_slug" }
        expect(flash[:danger]).to eq(I18n.t("category.no_have"))
      end
    end
  end

  describe 'private method load_categories' do
    let(:categories) { FactoryBot.create_list(:category, 3) }

    it 'loads categories into @categories instance variable' do
      allow(controller).to receive(:params).and_return(page: 1)
      controller.send(:load_categories)
      expect(assigns(:categories)).to match_array(categories)
    end
  end
end
