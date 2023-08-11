#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <detector/yolo_detector.hpp>
#include <iostream>

void TestYoloDetector(const std::string &path)
{
    std::cout<<"[TestYoloDetector] begin test..." << std::endl;
    trt::yolodetector::YoloDetector yolodetector;
    yolodetector.init(path);
    yolodetector.forward();
}


int main()
{
    std::string path = "";
    TestYoloDetector(path);
    return 0;
}