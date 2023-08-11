#ifndef _YOLO_MULTI_GPU_HPP
#define _YOLO_MULTI_GPU_HPP

#include "yolo.hpp"

namespace trt
{
namespace yolo
{

class MultiGPUInfer : public yolo::Infer
{
};

std::shared_ptr<MultiGPUInfer>
create_multi_gpu_infer(const std::string &engine_file, Type type, const std::vector<int> gpuids,
                       float confidence_threshold = 0.25f, float nms_threshold = 0.5f,
                       NMSMethod nms_method = NMSMethod::FastGPU, int max_objects = 1024);
} // namespace yolo
} // namespace trt

#endif // YOLO_MULTI_GPU_HPP