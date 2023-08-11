#ifndef TRT_APPS_SIMPLE_MODLE_HPP
#define TRT_APPS_SIMPLE_MODEL_HPP

#include <opencv2/core.hpp>

namespace trt {
namespace simpledetector
{

    class SimpleDetector
    {
    public:
        void init(const std::string &model_path);
        void forward();
    };
}
} // namespace trt

#endif