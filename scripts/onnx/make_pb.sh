#!/bin/bash

# 请修改protoc为你要使用的版本protoc
protoc=C:/.conan/f1d32b/1/bin/protoc
#protoc=/data/sxai/temp/protobuf-build3.18.x/bin/protoc

echo Create directory "pbout"
rm -rf pbout
mkdir -p pbout

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P)"
$protoc onnx-ml.proto --proto_path=$SCRIPT_DIR --cpp_out=pbout
$protoc onnx-operators-ml.proto --proto_path=$SCRIPT_DIR --cpp_out=pbout

echo Copy pbout/onnx-ml.pb.cc to $SCRIPT_DIR/../../src/tensorrt/onnx/onnx-ml.pb.cpp
cp pbout/onnx-ml.pb.cc           $SCRIPT_DIR/../../src/tensorrt/onnx/onnx-ml.pb.cpp

echo Copy pbout/onnx-operators-ml.pb.cc to $SCRIPT_DIR/../../src/tensorrt/onnx/onnx-operators-ml.pb.cpp
cp pbout/onnx-operators-ml.pb.cc $SCRIPT_DIR/../../src/tensorrt/onnx/onnx-operators-ml.pb.cpp

echo Copy pbout/onnx-ml.pb.h to $SCRIPT_DIR/../../src/tensorrt/onnx/onnx-ml.pb.h
cp pbout/onnx-ml.pb.h           $SCRIPT_DIR/../../src/tensorrt/onnx/onnx-ml.pb.h

echo Copy pbout/onnx-operators-ml.pb.h to $SCRIPT_DIR/../../src/tensorrt/onnx/onnx-operators-ml.pb.h
cp pbout/onnx-operators-ml.pb.h $SCRIPT_DIR/../../src/tensorrt/onnx/onnx-operators-ml.pb.h

echo Remove directory "pbout"
rm -rf pbout