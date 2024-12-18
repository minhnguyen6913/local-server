# Yêu cầu người dùng nhập tên cho image
read -p "Nhập phiên bản image (mặc định là 1): " ver
ver=${ver:-1}

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
echo "1. amd64"
echo "2. arm64 (Mặc định)"
read -p "Nhập lựa chọn (1, 2): " platform_choice

# Xử lý lựa chọn platform
case $platform_choice in
1)
  platform="linux/amd64"
  tag="amd64"
  ;;
*)
  platform="linux/arm64"
  tag="arm64"
  ;;
esac

# Chọn platform
echo "Chọn push:"
read -p "Nhập lựa chọn (y/N): " push

# Xử lý lựa chọn push
case $push in
y)
  push="--push"
  ;;
*)
  push=""
  ;;
esac

base="tamducjsc/lamp_webserver"
new_tag="$base:$dir-$tag-$ver"
# Thực hiện lệnh Docker build với các thông số đã nhập
docker_build_command="docker buildx build -t $new_tag -f bin/$dir/Dockerfile $push . --platform $platform --build-arg PLATFORM=$platform  --no-cache "

echo "#########################################################################################################"
# Chọn platform
echo "Câu lệnh Docker build:"
echo $docker_build_command
read -p "Có chạy (y/N): " run

login="docker login"

# Xử lý lựa chọn push
case $run in
y)
  eval $login
  eval $docker_build_command
  echo "Build finish for : $new_tag"
  ;;
*)
  echo "Not run"
  ;;
esac
