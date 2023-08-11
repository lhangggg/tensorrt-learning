#ifndef TENSORRT_LEARNING_YOLO_DETECTOR_HPP
#define TENSORRT_LEARNING_YOLO_DETECTOR_HPP

#include <opencv2/core.hpp>

namespace trt {
namespace yolodetector 
{

    class YoloDetector
    {
    public:
        void init(const std::string &model_path);
        void forward();
    };
}
} // namespace trt

#endif