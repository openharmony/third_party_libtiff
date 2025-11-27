# libtiff

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
OpenHarmony主要编译使用libtiff仓库中libtiff/目录下的源代码和头文件。libtiff通常作为图像框架或打印服务的依赖模块，来实现具体的TIFF格式图片的加载与解码功能。

### 1. libtiff的编译
libtiff 的编译入口在其根目录下的BUILD.gn中。简单示意如下：

```
# 定义源码列表
libtiff_source = [
    "//third_party/libtiff/libtiff/tif_aux.c",
    "//third_party/libtiff/libtiff/tif_close.c",
    "//third_party/libtiff/libtiff/tif_codec.c",
    "//third_party/libtiff/libtiff/tif_color.c",
    "//third_party/libtiff/libtiff/tif_compress.c",
    "//third_party/libtiff/libtiff/tif_dir.c",
    "//third_party/libtiff/libtiff/tif_dirinfo.c",
    "//third_party/libtiff/libtiff/tif_dirread.c",
    "//third_party/libtiff/libtiff/tif_dirwrite.c",
    "//third_party/libtiff/libtiff/tif_dumpmode.c",
    "//third_party/libtiff/libtiff/tif_error.c",
    "//third_party/libtiff/libtiff/tif_extension.c",
    "//third_party/libtiff/libtiff/tif_fax3.c",
    "//third_party/libtiff/libtiff/tif_fax3sm.c",
    "//third_party/libtiff/libtiff/tif_flush.c",
    "//third_party/libtiff/libtiff/tif_getimage.c",
    # ... 其他 tif_*.c 文件
    "//third_party/libtiff/libtiff/tif_version.c",
    "//third_party/libtiff/libtiff/tif_write.c",
    "//third_party/libtiff/libtiff/tif_zip.c",
]

ohos_shared_library("libtiff") {
    sources = libtiff_source
    
    include_dirs = [
        "//third_party/libtiff/libtiff",
    ]

    # libtiff 通常依赖 zlib 和 libjpeg 来支持特定的压缩格式
    external_deps = [
        "zlib:libz",
        "libjpeg-turbo:turbojpeg",
    ]

    subsystem_name = "thirdparty"
    part_name = "libtiff"
    output_name = "libtiff"
    output_extension = "so"
    install_images = [ "system" ]
    ldflags = [ "-Wl,-Map=libtiff.map" ]
}
```
### 2. 使用libtiff

在需要使用libtiff的模块构建配置中，增加对应依赖，示例如下：

```
ohos_shared_library("tiffplugin") {

  sources = [
    ......
  ]

  include_dirs = [
    ......
  ]

  external_deps = [
    "libtiff:libtiff",
  ]

...
}
```

## libtiff相关内容

[libtiff主页](https://gitlab.com/libtiff/libtiff) 
[libtiff文档](https://libtiff.gitlab.io/libtiff/)

## License

libtiff使用LibTIFF License(一种类 BSD 协议)，详见仓库根目录下的LICENSE.md文件。