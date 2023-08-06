from conans import ConanFile, CMake

class TensorRtLean(ConanFile):
    name = "tensorrtlean"
    version = "0.1.0"
    author = "Lhang Corporation"
    description = "lhang tensorrt learning library"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": True, "fPIC": True}
    generators = "cmake", "cmake_find_package", "virtualrunenv"

    def requirements(self):
        if self.settings.os == "Windows":
            # dynamic linking
            self.requires("opencv/4.5.3")
            # static linking
            self.requires("protobuf/3.17.1", private=True)
            self.requires("eigen/3.3.9", private=True)

            # not for output
            # self.requires("pybind11/2.9.1", private=True)
        
        if self.settings.os == "Linux":
            if self.settings.arch == "x86_64":
                # dynamic linking
                self.requires("opencv/4.5.3")
                # static linking
                self.requires("protobuf/3.17.1", private=True)
                self.requires("eigen/3.3.9", private=True)

                # not for output
                # self.requires("pybind11/2.9.1", private=True)

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC
            
    def package_info(self):
        self.cpp_info.name = "tensorrt_learning"
        self.cpp_info.includedirs = ["include"]
        self.cpp_info.libdirs = ["lib"]
