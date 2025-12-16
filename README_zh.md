# libtiff

原始仓来源：https://gitlab.com/libtiff/libtiff


仓库包含第三方开源软件libtiff，libtiff用于读取、写入和操作TIFF（Tagged Image File Format）图像文件。它提供了一套标准化的接口来处理TIFF格式的各种复杂特性，包括多种压缩算法（如 LZW, Deflate, JPEG 等）的支持。在OpenHarmony中，libtiff主要作为媒体子系统的基础组件，提供TIFF图片格式的解码能力。

## 目录结构

```
archive/    过往归档文件
build/      构建辅助脚本
cmake/      CMake构建配置文件
contrib/    社区贡献的非核心代码
doc/        说明文档
libtiff/    libtiff核心库源代码及头文件
port/       平台兼容性接口代码
test/       测试脚本和用例
tools/      tiffcp, tiffdump等二进制工具源码
README.md   README说明
```

## OpenHarmony如何使用libtiff

OpenHarmony的系统部件需要在BUILD.gn中引用libtiff部件以使用libtiff。
```
// BUILD.gn
external_deps += [ "libtiff:libtiff" ]
```

## 使用libtiff库解码步骤

1. 打开文件

  ```
  TIFF *TIFFOpen(const char *filename, const char *mode);
  filename：文件名
  mode：打开模式（"r"表示读取）
  ```

2. 读取图片的元数据

  ```
  int TIFFGetField(TIFF *tif, uint32_t tag, ...);
  tif：TIFF文件上下文环境
  tag：要读取的元数据标签
  ...：可变参数，用于接收tag值 

  具体示例如：
  TIFFGetField(tif, TIFFTAG_IMAGEWIDTH, &imgWidth);
  ```

3. 图片解码

  ```
  int TIFFReadRGBAImage(TIFF *tif, uint32_t width, uint32_t height, uint32_t *raster, int stopOnError);
  tif：TIFF文件上下文环境
  width：图片宽度
  height：图片高度
  raster：接收解码后像素数据的内存首地址
  stopOnError：错误处理策略，设为非0值则遇错立即终止；设为0则尝试跳过错误继续解码。

  具体示例如：
  uint32_t *raster = (uint32_t *)_TIFFmalloc(width * height * sizeof(uint32_t));
  if (raster != NULL) {
    if (TIFFReadRGBAImage(tif, width, height, raster, 0)) {
      // 解码成功，处理 raster 中的数据
    }
    _TIFFfree(raster);
  }
  ```

4. 关闭文件

  ```
  void TIFFClose(TIFF *tif)；
  tif：TIFF文件上下文环境
  ```

## 约束与扩展

OpenHarmony目前仅集成了libtiff的解码能力，用于读取和显示tiff图片。除解码外，libtiff本身还具备编码能力，支持修改、添加或删除TIFF文件的元数据标签。

扩展能力举例（写入TIFF图片）：

1. 打开文件用于写入

  ```
  TIFF *TIFFOpen(const char *filename, const char *mode);
  filename：文件名
  mode：打开模式（"w"表示写入）
  ```

2. 设置必要的元数据标签

  ```
  int TIFFSetField(TIFF *tif, uint32_t tag, ...);
  tif：TIFF文件上下文环境
  tag：要设置的元数据标签
  ...：可变参数，传入tag对应的值 

  具体示例如：
  //设置基本信息：宽、高、位深、压缩方式等
  TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, width);
  TIFFSetField(tif, TIFFTAG_IMAGELENGTH, height);
  TIFFSetField(tif, TIFFTAG_SAMPLESPERPIXEL, 3); // RGB
  TIFFSetField(tif, TIFFTAG_BITSPERSAMPLE, 8);   // 8位
  TIFFSetField(tif, TIFFTAG_COMPRESSION, COMPRESSION_LZW); // LZW压缩
  ```

3. 写入像素数据

  ```
  int TIFFWriteScanline(TIFF *tif, void *buf, uint32_t row, uint16_t sample);
  tif：TIFF文件上下文环境
  buf：包含当前行像素数据的缓冲区
  row：当前写入的行号
  sample：样本索引（通常为0）

  具体示例如：
  for (int row = 0; row < height; row++) {
    if (TIFFWriteScanline(tif, &buf[row * width * 3], row, 0) < 0) {
        break; // 写入失败
    }
  }
  ```

4. 关闭并保存文件

  ```
  void TIFFClose(TIFF *tif)；
  tif：TIFF文件上下文环境
  ```


更多libtiff接口可以参考https://libtiff.gitlab.io/libtiff/functions.html

## License

libtiff使用LibTIFF License(一种类 BSD 协议)，详见仓库根目录下的LICENSE.md文件。