// app/assets/javascripts/categories.js
$(document).on('turbolinks:load', function () {
  $('.category-list li a').on('click', function (e) {
    e.preventDefault();
    var categorySlug = $(this).data('slug');

    $.ajax({
      url: '/categories/' + categorySlug,
      method: 'GET',
      dataType: 'script',
      success: function (data) {
        // Xử lý dữ liệu và cập nhật danh sách cuisine ở đây
      }
    });
  });
});
