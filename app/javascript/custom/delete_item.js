document.addEventListener("DOMContentLoaded", function() {
  const deleteButtons = document.querySelectorAll(".delete-order-item-button");

  deleteButtons.forEach(button => {
    button.addEventListener("click", function() {
      const index = this.getAttribute("data-index");
      const shouldDelete = confirm("Bạn có chắc chắn muốn xóa đơn hàng này không?");

      if (shouldDelete) {
        // Gửi yêu cầu xóa đơn hàng đến máy chủ bằng AJAX
        fetch(`/orders/delete_item?index=${index}`)
          .then(response => response.json())
          .then(data => {
            if (data.success) {
              // Nếu xóa thành công, cập nhật lại giao diện
              window.location.reload();
            } else {
              alert("Đã xảy ra lỗi khi xóa đơn hàng.");
            }
          })
          .catch(error => {
            console.error("Lỗi: " + error);
            alert("Đã xảy ra lỗi khi xóa đơn hàng.");
          });
      }
    });
  });
});
