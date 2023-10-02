RSpec.shared_examples "authorization" do |action|
    it "redirects to root path" do
      action
      expect(response).to redirect_to root_path
    end
end
