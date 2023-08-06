#!/bin/bash

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P)"
echo Remove $SCRIPT_DIR/../../src/tensorrt/onnx_parser
rm -rf $SCRIPT_DIR/../../src/tensorrt/onnx_parser

echo Copy [$SCRIPT_DIR/onnx_parser_7.x] to [$SCRIPT_DIR/../../src/tensorrt/onnx_parser]
cp -r $SCRIPT_DIR/onnx_parser_7.x $SCRIPT_DIR/../../src/tensorrt/onnx_parser

echo Configure your tensorRT path to 7.x
echo After that, you can execute the command 'make yolo -j64'
