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

OpenHarmony中系统部件需要在BUILD.gn中引用libtiff部件以使用libtiff。
```
// BUILD.gn
external_deps += [ "libtiff:libtiff" ]
```

## 使用libtiff库解码步骤

1. 打开文件
   ```
   TIFF *TIFFOpen(const char *filename, const char *mode);
   filename 是文件名
   mode 是指定文件将被打开以进行读取或写入或追加等权限
   ```
2. 读取/写入图片的元数据
   ```
   int TIFFGetField(TIFF *tif, uint32_t tag, ...);

   tif是tif上下文环境
   tag是读取的元数据标签
   ...是可变参数列表，用于接收tag值 
   具体示例如：
   TIFFGetField(tif, TIFFTAG_IMAGEWIDTH, &imgWidth);
   ```
3. 图片解码
   ```
   int TIFFReadRGBAImage(TIFF *tif, uint32_t width, uint32_t height, uint32_t *raster, int stopOnError);
   tif是tif上下文环境
   width是图片的宽度
   height是图片的高度
   raster是图片像素返回的内存
   stopOnError指定错误发生时如何处理，如果stopOnError不为零，则错误将终止操作；否则将继续处理数据，直到所有可能的数据在 已请求图像。
   ```
4. 关闭文件
   ```
   void TIFFClose(TIFF *tif)；
   tif是tif上下文环境
   ```
更多libtiff接口可以参考https://libtiff.gitlab.io/libtiff/functions.html

## License

libtiff使用LibTIFF License(一种类 BSD 协议)，详见仓库根目录下的LICENSE.md文件。