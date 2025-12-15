# libtiff
原始仓来源：https://gitlab.com/libtiff/libtiff


仓库包含第三方开源软件libtiff，libtiff用于读取、写入和操作TIFF（Tagged Image File Format）图像文件。它提供了一套标准化的接口来处理TIFF格式的各种复杂特性，包括多种压缩算法（如 LZW, Deflate, JPEG 等）的支持。在OpenHarmony中，libtiff主要作为图形图像子系统的基础组件，提供TIFF图片格式的编解码能力。

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

## 使用场景
OpenHarmony编译使用libtiff仓库中libtiff/目录下的源代码和头文件。libtiff通常作为图像框架的依赖模块，来实现具体的TIFF格式图片的加载与解码功能。

### 1. libtiff的编译

libtiff引入OpenHarmony的thirdparty目录下，使用OpenHarmony中依赖部件的方式进行编译。更多信息参考：https://gitee.com/openharmony/manifest/tree/master


（1）主干代码下载
```
repo init -u https://gitee.com/openharmony/manifest.git -b master --no-repo-verify
repo sync -c
repo forall -c 'git lfs pull'
```

（2）在使用的模块进行依赖
```
deps = ["//third_party/libtiff:libtiff"]
```

（3）预处理
```
./build/prebuilts_download.sh
```

（4）编译
```
./build.sh --product-name {product_name}
```


### 3. OpenHarmony中的使用

（1）面向对象
系统开发者， tiff图像相关开发者

（2）指导参考

开发者在需要使用libtiff的模块下，配置BUILD.gn，添加依赖：
参考链接：https://gitee.com/openharmony/build/tree/master
```
import("//build/ohos.gni")
ohos_shared_library("helloworld") {
  sources = ["demo.cpp"]
  include_dirs = []
  cflags = []
  cflags_c = []
  cflags_cc = []
  ldflags = []
  configs = []
  deps =[]  # 部件内模块依赖

  external_deps = [
    "libtiff:libtiff",
  ]

  output_name = ""           # 可选，模块输出名
  output_extension = ""      # 可选，模块名后缀
  module_installinstall_dir = ""  # 可选，模块安装相对路径，相对于/system/lib64或/system/lib；如果有module_install_dir配置时，该配置不生效
  install_images = []        # 可选，缺省值system，指定模块安装到那个分区镜像中，可以指定多个

  part_name = "" # 必选，所属部件名称
}

```

demo.cpp引入头文件，使用相应的函数，具体指导参考：[libtiff文档](https://libtiff.gitlab.io/libtiff/)
```
#include <iostream>
#include "tiffio.h"

void ReadTiffInfo(const char* fileName) {
  // 打开TIFF文件
  TIFF* tif = TIFFOpen(fileName, "r");
  if (!tif) {
    std::cerr << "Failed to open TIFF file."<< std::endl;
    return;
  }
  uint32_t width, height;
  // 读取图片的宽和高（Tag: ImageWidth, ImageLength）
  TIFFGetField(tif, TIFFTAG_IMAGEWIDTH, &width);
  TIFFGetField(tif, TIFFTAG_IMAGELENGTH, &height);

  std::cout << "Image Size":" << width << "x" << height << std::endl;

  //关闭文件
  TIFFClose();
}
```

## License

libtiff使用LibTIFF License(一种类 BSD 协议)，详见仓库根目录下的LICENSE.md文件。