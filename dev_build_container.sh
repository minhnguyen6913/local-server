# Hiển thị menu lựa chọn cho người dùng
echo "Choose:"
echo "1. Build test php image"
echo "2. Publish php image"

# Đọc lựa chọn từ người dùng
read -p "Your choice (1, 2): " choice

# Xử lý lựa chọn của người dùng
case $choice in
1)
        echo "Start php build option:"
        # Thực hiện các công việc khác trong script
        sh bin/assets/sh/php_build_test.sh
        ;;
2)
        echo "Build"
        # Thực hiện công việc 2 ở đây
        sh bin/assets/sh/php_build_prod.sh
        ;;
*)
        echo "Lựa chọn không hợp lệ."
        ;;
esac
