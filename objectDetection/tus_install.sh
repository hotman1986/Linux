echo "获取当前路径..."
basepath=$(cd `dirname $0`; pwd)

echo "建立工作文件夹 ~/workRoot..."
mkdir ~/workRoot

echo "建立软件安装文件夹~/workRoot/program..."
mkdir ~/workRoot/program

echo "建立Qt安装目录~/workRoot/program/Qt5.10.1..."
mkdir ~/workRoot/program/Qt5.10.1

echo "建立数据文件夹..."
mkdir ~/workRoot/data

echo "拷贝测试数据..."
cp ./VID20190131150124.mp4 ~/workRoot/data/

echo "拷贝openCV3.4.5..."
cp -r ./opencv-3.4.5 ~/workRoot/program

echo "拷贝darknet-master..."
cp -r ./darknet-master ~/workRoot

echo "拷贝离线安装包..."
cp ./archives/*.deb /var/cache/apt/archives/

echo "切换apt到清华源..."
rm /etc/apt/sources.list
cp ./sources.list /etc/apt/
apt-get update

echo "安装HDMIDriver依赖库..."
apt install libva1
apt install libva-x11-1
apt install libva-drm1

echo "安装MDMI卡驱动..."
cp ./HDMIDriver/QP0203.AUDFW.BIN /lib/firmware/
cp ./HDMIDriver/QP0203.VIDFW.BIN /lib/firmware/
cp ./HDMIDriver/LXV4L2D_PL330B.ko /lib/modules/4.15.0-46-generic/
depmod -a
modprobe LXV4L2D_PL330B

echo "安装ssh-server..."
sudo apt-get install openssh-server
rm /etc/rc.local
cp ./rc.local /etc/

echo "安装Qt..."
./qt-opensource-linux-x64-5.10.1.run
apt-get install libgl1-mesa-dev libglu1-mesa-dev

echo "安装cmake..."
apt install cmake

echo "安装teamViewer..."
dpkg -i ./TeamViewerLinux/teamviewer_13.0.6634_amd64.deb
apt-get update
apt-get -f install
dpkg -i ./TeamViewerLinux/teamviewer_13.0.6634_amd64.deb

echo "编译安装opencv..."
apt-get install build-essential
apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
mkdir ~/workRoot/program/opencv-3.4.5/build
cd ~/workRoot/program/opencv-3.4.5/build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local -D CMAKE_BUILD_TYPE=Release -D OPENCV_EXTRA_MODULES_PATH=~/workRoot/program/opencv-3.4.5/opencv_contrib/modules ..
make -j8
make install
cd $basepath

echo "配置openCV环境变量..."
cp ./opencv.conf /etc/ld.so.conf.d/
ldconfig
echo 'PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig'>>/etc/bash.bashrc
echo 'export PKG_CONFIG_PATH'>>/etc/bash.bashrc

echo "安装显卡驱动..."
apt-get purge nvidia*
add-apt-repository ppa:graphics-drivers
apt-get update
apt-cache search nvidia
apt-get install nvidia-415

echo "安装CUDA..."
echo "请按enter进行安装"
sh ./cuda_10.0.130_410.48_linux.run
cp /usr/local/cuda-10.0/lib64/libcudart.so.10.0 /usr/local/lib/libcudart.so.10.0
cp /usr/local/cuda-10.0/lib64/libcublas.so.10.0 /usr/local/lib/libcublas.so.10.0
cp /usr/local/cuda-10.0/lib64/libcurand.so.10.0 /usr/local/lib/libcurand.so.10.0
ldconfig

echo "安装NVCC..."
sudo apt install nvidia-cuda-toolkit
nvcc --version

echo "配置CUDA环境变量..."
echo "export PATH=/usr/local/cuda-10.0/bin:\$PATH">>/etc/profile
echo "export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64:\$LD_LIBRARY_PATH">>/etc/profile
cp ./cuda.conf /etc/ld.so.conf.d/
ldconfig -v

echo "安装CUDNN..."
cp ./cuda/lib64/* /usr/local/cuda/lib64/
cp ./cuda/include/* /usr/local/cuda/include/
rm -rf /usr/local/cuda/lib64/libcudnn.so /usr/local/cuda/lib64/libcudnn.so.7
chmod u=rwx,g=rx,o=rx /usr/local/cuda/lib64/libcudnn.so.7.5.0
ln -s /usr/local/cuda/lib64/libcudnn.so.7.5.0 /usr/local/cuda/lib64/libcudnn.so.7
ln -s /usr/local/cuda/lib64/libcudnn.so.7 /usr/local/cuda/lib64/libcudnn.so

echo "编译测试darknet..."
cd ~/workRoot/darknet-master
make clean
make -j8
#~/workRoot/darknet-master/darknet detect cfg/yolov3.cfg yolov3.weights data/dog.jpg
cd $basepath
echo "重启系统..."
reboot

