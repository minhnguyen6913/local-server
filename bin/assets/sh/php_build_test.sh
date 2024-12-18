# Yêu cầu người dùng nhập tên cho image
read -p "Nhập tên cho image (mặc định là test): " image_name
image_name=${image_name:-test}

# Yêu cầu người dùng nhập đường dẫn đến Dockerfile và kiểm tra xem họ đã nhập hay chưa
while true; do
  read -p "Nhập  option image: php74... (*): " dir
  if [ -z "$dir" ]; then
    echo "Đường dẫn đến Dockerfile là bắt buộc. Vui lòng nhập đường dẫn."
  else
    break
  fi
done

# Chọn platform
echo "Chọn platform:"
echo "1. linux/amd64"
echo "2. linux/arm64"
echo "3. linux/arm64/v8"
echo "4. Full 1,2,3 "
read -p "Nhập lựa chọn (1, 2, 3, 4): " platform_choice

# Xử lý lựa chọn platform
case $platform_choice in
1)
  platform="linux/amd64"
  ;;
2)
  platform="linux/arm64"
  ;;
3)
  platform="linux/arm64/v8"
  ;;
4)
  platform="linux/amd64,linux/arm64,linux/arm64/v8 "
  ;;
*)
  echo "Lựa chọn không hợp lệ. Sử dụng platform mặc định linux/arm64."
  platform="linux/arm64"
  ;;
esac

# Thực hiện lệnh Docker build với các thông số đã nhập
docker_build_command="docker build -t $image_name -f bin/$dir/Dockerfile . --platform $platform --build-arg PLATFORM=$platform"
echo "Câu lệnh Docker build:"
echo $docker_build_command

eval $docker_build_command

#docker build -t webserver74 -f bin/php74/Dockerfile . --platform linux/arm64 --build-arg PLATFORM=linux/arm64
