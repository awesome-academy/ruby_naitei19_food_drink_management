module CuisineHelper
  def cuisine_available_class cuisine
    cuisine.available? ? "cuisine-link" : "cuisine-not-available"
  end

  def cuisine_image cuisine
    cuisine.image || "image_not_available.jpg"
  end

  def cuisine_image_class cuisine
    cuisine.available? ? "cuisine-image" : "cuisine-image-not-available"
  end
end
