require "rails_helper"

RSpec.describe Admin::CuisinesController, type: :controller do
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let(:non_admin_user) { FactoryBot.create(:user) }
  
  describe "when not logged in" do
    it "redirects to the login page for any action" do
      get :index
      expect(response).to redirect_to(login_path)
      
      get :new
      expect(response).to redirect_to(login_path)

      post :create
      expect(response).to redirect_to(login_path)

      get :edit, params: { slug: "some-cuisine" }
      expect(response).to redirect_to(login_path)

      patch :update, params: { slug: "some-cuisine" }
      expect(response).to redirect_to(login_path)

      delete :destroy, params: { slug: "some-cuisine" }
      expect(response).to redirect_to(login_path)
    end
  end

  describe "when logged in as a non-admin user" do
    before do
      sign_in non_admin_user
    end

    it "redirects to the root page for any action" do
      get :index
      expect(response).to redirect_to(root_path)
      
      get :new
      expect(response).to redirect_to(root_path)

      post :create
      expect(response).to redirect_to(root_path)

      get :edit, params: { slug: "some-cuisine" }
      expect(response).to redirect_to(root_path)

      patch :update, params: { slug: "some-cuisine" }
      expect(response).to redirect_to(root_path)

      delete :destroy, params: { slug: "some-cuisine" }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "when logged in as an admin user" do
    before do
      sign_in admin_user
    end

    describe "GET #index" do
      before do
        FactoryBot.create_list(:cuisine, 3, :category)
        get :index
      end
      it "responds with HTTP status 200" do
        expect(response).to have_http_status(200)
      end

      it "renders the index template" do
        expect(response).to render_template("index")
      end

      it "assigns @cuisines with a list of cuisines" do
        expect(assigns(:cuisines)).not_to be_nil
        expect(assigns(:cuisines).length).to eq(3)
      end
    end

    describe "GET #new" do
      it "assigns a new cuisine" do
        get :new
        expect(assigns(:cuisine)).to be_a_new(Cuisine)
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      context "with valid parameters" do
        let(:valid_cuisine_params) do
          {
            cuisine: {
              name: "Test Cuisine",
              description: "Test description",
              slug: "test-cuisine",
              price: 10000,
              discount: 5,
              available: true,
              category_id: FactoryBot.create(:category).id,
              image: Rack::Test::UploadedFile.new(Rails.root.join("spec", "support", "assets", "example.jpg"), "image/jpeg")
            }
          }
        end

        it "creates a new cuisine" do
          expect do
            post :create, params: valid_cuisine_params
          end.to change(Cuisine, :count).by(1)
        end

        it "redirects to the edit page of the new cuisine" do
          post :create, params: valid_cuisine_params
          expect(response).to redirect_to(edit_admin_cuisine_path(slug: assigns(:cuisine).slug))
        end

        it "sets a success flash message" do
          post :create, params: valid_cuisine_params
          expect(flash[:success]).to be_present
        end
      end

      context "with invalid parameters" do
        let(:invalid_cuisine_params) do
          {
            cuisine: {
              name: "",
              description: "Test description",
              slug: "test-cuisine",
              price: 10000,
              discount: 5,
              available: true,
              category_id: FactoryBot.create(:category).id,
              image: Rack::Test::UploadedFile.new(Rails.root.join("spec", "support", "assets", "example.jpg"), "image/jpeg")
            }
          }
        end

        it "does not create a new cuisine" do
          expect do
            post :create, params: invalid_cuisine_params
          end.not_to change(Cuisine, :count)
        end

        it "re-renders the new template" do
          post :create, params: invalid_cuisine_params
          expect(response).to render_template(:new)
        end

        it "sets a danger flash message" do
          post :create, params: invalid_cuisine_params
          expect(flash[:danger]).to be_present
        end
      end
    end

    describe "GET #edit" do
      let(:cuisine) { FactoryBot.create(:cuisine, :category) }

      it "assigns the requested cuisine to @cuisine" do
        get :edit, params: { slug: cuisine.slug }
        expect(assigns(:cuisine)).to eq(cuisine)
      end

      it "renders the edit template" do
        get :edit, params: { slug: cuisine.slug }
        expect(response).to render_template(:edit)
      end
    end

    describe "PATCH #update" do
      let(:cuisine) { FactoryBot.create(:cuisine, :category) }
      let(:updated_attributes) { { name: "Updated Cuisine Name" } }

      it "assigns the requested cuisine to @cuisine" do
        patch :update, params: { slug: cuisine.slug, cuisine: updated_attributes }
        expect(assigns(:cuisine)).to eq(cuisine)
      end

      context "with valid attributes" do
        it "updates the cuisine" do
          patch :update, params: { slug: cuisine.slug, cuisine: updated_attributes }
          cuisine.reload
          expect(cuisine.name).to eq("Updated Cuisine Name")
        end

        it "redirects to the edit page" do
          patch :update, params: { slug: cuisine.slug, cuisine: updated_attributes }
          expect(response).to redirect_to(edit_admin_cuisine_path(slug: cuisine.slug))
        end
      end

      context "with invalid attributes" do
        it "does not update the cuisine" do
          patch :update, params: { slug: cuisine.slug, cuisine: { name: "" } }
          cuisine.reload
          expect(cuisine.name).not_to eq("")
        end

        it "re-renders the edit template" do
          patch :update, params: { slug: cuisine.slug, cuisine: { name: "" } }
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:category) { FactoryBot.create(:category) }
      let!(:cuisine) { FactoryBot.create(:cuisine, category: category) }

      it "destroys the cuisine" do
        expect {
          delete :destroy, params: { slug: cuisine.slug }
        }.to change(Cuisine, :count).by(-1)
      end

      it "redirects to admin_cuisines_path" do
        delete :destroy, params: { slug: cuisine.slug }
        expect(response).to redirect_to(admin_cuisines_path)
      end

      it "sets a flash message" do
        delete :destroy, params: { slug: cuisine.slug }
        expect(flash[:success]).to be_present
      end
    end
  end
end
