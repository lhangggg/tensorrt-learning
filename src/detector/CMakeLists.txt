# add_app_cuda(
#     APP_NAME simple_model
#     APP_SRCS ./simple_model/simple_model.cpp
#     APP_DEPS tensorrt_tool
# )

add_app_cuda(
    APP_NAME yolo_detector
    APP_SRCS ./yolo_detector/yolo_detector.cpp ./yolo_detector/yolo.hpp ./yolo_detector/yolo.cpp ./yolo_detector/multi_gpu.hpp ./yolo_detector/multi_gpu.cpp ./yolo_detector/yolo_decode.cu
    APP_DEPS tensorrt_tool
)