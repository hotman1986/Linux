source /etc/bash.bashrc
echo "查询OpenCV版本..."
pkg-config --modversion opencv

source /etc/profile
echo "查询CUDA版本..."
nvcc --version

echo "显卡驱动查询..."
nvidia-smi

echo "测试darknet运行是否成功"
cd ~/workRoot/darknet-master
sudo ~/workRoot/darknet-master/darknet detect cfg/yolov3.cfg yolov3.weights data/dog.jpg
