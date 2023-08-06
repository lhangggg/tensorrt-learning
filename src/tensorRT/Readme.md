### 封装

视频教程：[关于封装](https://www.bilibili.com/video/BV1Xw411f7FW?p=6&vd_source=a33f8ee4ea72155af6cab1287303e9d6)

Tensor 封装：
  1. CPU/GPU 内存自动分配释放，内存复用
  2. CPU/GPU 之间自动内存赋值
  3. 计算维度的偏移量

封装目的：降低tensorRT的使用门槛和集成难度，避免重复代码，关注业务逻辑，而非复杂的细节。
1. Tensor类：实现张量的内存管理、维度管理、偏移量计算、cpu/gpu相互自动拷贝。避免手动管理内存、计算偏移量。
2. Infer类：实现TensorRT引擎的推理管理，自动关联引擎的输入、输出；
3. Builer：实现onnx到引擎转换的封装，int8封装，少数几行代码实现需求；
4. plugin：封装插件的细节、序列化、反序列化、creator、tensor和weight等，只需要关注具体推理部分，避免面临大量复杂情况。