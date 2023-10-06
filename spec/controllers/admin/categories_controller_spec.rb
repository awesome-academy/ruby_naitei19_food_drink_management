require "rails_helper"

RSpec.describe Admin::CategoriesController, type: :controller  do
  let!(:admin_user) { create(:admin_user) }
  let!(:user) { create(:user) }

  shared_context "logged in as a user" do
    before do
      sign_in user
    end
  end

  shared_context "logged in as an admin" do
    before do
      sign_in admin_user
    end
  end

  describe "GET /index" do
    context "logged in user is admin" do
      include_context "logged in as an admin"

      it "render the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end

    context "logged in user ís not an admin" do
      include_context "logged in as a user"

      let!(:action) { get :index }
      include_examples "authorization", :action
    end
  end

  describe "GET /new" do
    context "logged in user is admin" do
      include_context "logged in as an admin"

      it "assigns a new category to @category" do
        get :new
        expect(assigns(:category)).to be_a_new(Category)
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template("new")
      end
    end

    context "logged in user ís not an admin" do
      include_context "logged in as a user"
      let!(:action) { get :new }

      include_examples "authorization", :action
    end
  end

  describe "POST /create" do
    let(:invalid_params){ attributes_for(:category, name: "") }

    context "logged in user is admin" do
      include_context "logged in as an admin"

      context "with valid params" do
        it "creates a new category" do
          expect{
            post :create,
            params: {category: attributes_for(:category)}
          }.to change(Category, :count).by(1)
        end

        it "redirects to categories path" do
          post :create, params: {category: attributes_for(:category)}
          expect(response).to redirect_to(admin_categories_path)
        end

        it "display flash success" do
          post :create, params: {category: attributes_for(:category)}
          expect(flash[:success]).to eq I18n.t("admin.categories.create.success")
        end
      end

      context "with invalid params" do
        it "does not save the category" do
          expect {
            post :create,
            params: {category: invalid_params}
          }.to_not change(Category, :count)
        end

        it "re-renders the new template" do
          post :create, params: {category: invalid_params}
          expect(response).to render_template(:new)
        end

        it "display flash danger" do
          post :create, params: {category: invalid_params}
          expect(flash[:danger]).to eq I18n.t("admin.categories.create.fail")
        end
      end
    end

    context "logged in user ís not an admin" do
      include_context "logged in as a user"
      let!(:action) { post :create }

      include_examples "authorization", :action
    end
  end

  describe "PUT /update" do
    let(:category){create(:category)}

    context "logged in user is admin" do
      include_context "logged in as an admin"

      context "with valid params" do
        let(:new_name) {"New Category Name"}

        before do
          patch :update,
          params: {slug: category.slug, category: attributes_for(:category, name: new_name)}
        end

        it "update @category attributes" do
          expect(category.reload.name).to eq(new_name)
        end

        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("admin.categories.update.success")
        end

        it "redirects to categories path" do
          expect(response).to redirect_to(admin_categories_path)
        end
      end

      context "with invalid params" do
        before do
          patch :update,
          params: {slug: category.slug, category: attributes_for(:category, name: "")}
        end

        it "does not update the category" do
          expect(category.reload.name).not_to eq("")
        end

        it "re-renders the edit template" do
          expect(response).to render_template(:edit)
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("admin.categories.update.fail")
        end
      end

      context "with duplicates slug" do
        let!(:category_1) { create(:category, name: "category 1", slug: "category-1") }
        let!(:category_2) { create(:category, name: "category 2", slug: "category-2") }

        it "display flash danger" do
          patch :update,
          params: {slug: category_1.slug, category: attributes_for(:category, name: "category 2")}
          expect(flash[:danger]).to eq I18n.t("admin.categories.update.duplicate_slug")
        end
      end
    end

    context "logged in user ís not an admin" do
      include_context "logged in as a user"
      let!(:action) {  patch :update, params: {slug: category.slug, category: attributes_for(:category)} }

      include_examples "authorization", :action
    end
  end

  describe "DELETE /destroy" do
    let!(:category) { create(:category) }
    context "logged in user is admin" do
      include_context "logged in as an admin"

      context "when the category is deleted successfully" do
        it "display flash success" do
          delete :destroy, params: {slug: category.slug}
          expect(flash[:success]).to eq I18n.t("admin.categories.destroy.success")
        end

        it "redirects to categories path" do
          delete :destroy, params: {slug: category.slug}
          expect(response).to redirect_to(admin_categories_path)
        end
      end

      context "when the category fails to delete" do
        before{ allow_any_instance_of(Category).to receive(:destroy).and_return(false) }

        it "display flash danger" do
          delete :destroy, params: {slug: category.slug}
          expect(flash[:danger]).to eq I18n.t("admin.categories.destroy.fail")
        end

        it "redirects to categories path" do
          delete :destroy, params: {slug: category.slug}
          expect(response).to redirect_to(admin_categories_path)
        end
      end
    end

    context "logged in user ís not an admin" do
      include_context "logged in as a user"
      let!(:action) {  patch :update, params: {slug: category.slug} }

      include_examples "authorization", :action
    end
  end
end
