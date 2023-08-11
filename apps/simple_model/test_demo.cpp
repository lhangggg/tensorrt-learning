#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <application/simple_model.hpp>
#include <iostream>

void TestDemo(const std::string &path)
{
    std::cout<<"[TestDemo] begin test..." << std::endl;
    trt::simplemodel::SimpleDetector simpledetector;
    simpledetector.init(path);
    simpledetector.forward();
}


int main()
{
    std::string path = "";
    TestDemo(path);
    return 0;
}