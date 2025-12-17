# libtiff

Original Repository: https://gitlab.com/libtiff/libtiff


This repository contains libtiff, a third-party open-source software used for reading, writing, and manipulating TIFF (Tagged Image File Format) images. It provides a standardized set of interfaces to handle various complex features of the TIFF format, including support for multiple compression algorithms (e.g., LZW, Deflate, JPEG, etc.). In OpenHarmony, libtiff primarily serves as a foundational component of the media subsystem, providing decoding capabilities for TIFF image formats.

## Directory Structure

```
archive/    Past archived files
build/      Build helper scripts
cmake/      CMake build configuration files
contrib/    Non-core code contributed by the community
doc/        Documentation
libtiff/    Source code and header files for the libtiff core library
port/       Platform compatibility interface code
test/       Test scripts and cases
tools/      Source code for binary tools like tiffcp, tiffdump, etc.
README.md   README instructions
```

## How to Use libtiff in OpenHarmony

System components in OpenHarmony need to reference the libtiff component in BUILD.gn to use it.
```
// BUILD.gn
external_deps += [ "libtiff:libtiff" ]
```

## Decoding Steps Using libtiff

1. Open the file

  ```
  TIFF *TIFFOpen(const char *filename, const char *mode);
  filename: The name of the file
  mode: The file opening mode ("r" for reading)
  ```

2. Read image metadata

  ```
  int TIFFGetField(TIFF *tif, uint32_t tag, ...);
  tif：TIFF file context
  tag：The metadata tag to read
  ...：Variable argument list to receive the tag value

  Example:
  TIFFGetField(tif, TIFFTAG_IMAGEWIDTH, &imgWidth);
  ```

3. Decode the image

  ```
  int TIFFReadRGBAImage(TIFF *tif, uint32_t width, uint32_t height, uint32_t *raster, int stopOnError);
  tif：TIFF file context
  width：Image width
  height：Image height
  raster：Memory address of the first pixel data after decoding
  stopOnError：Error handling strategy. If non-zero, stop immediately on error; if zero, attempt to skip errors and continue decoding.

  Example:
  uint32_t *raster = (uint32_t *)_TIFFmalloc(width * height * sizeof(uint32_t));
  if (raster != NULL) {
    if (TIFFReadRGBAImage(tif, width, height, raster, 0)) {
      // 解码成功，处理 raster 中的数据
    }
    _TIFFfree(raster);
  }
  ```

4. Close the file

  ```
  void TIFFClose(TIFF *tif)；
  tif：TIFF file context
  ```

## Feature Support

OpenHarmony currently integrates libtiff primarily for decoding and displaying TIFF images. Encoding (writing) of TIFF images and modification of metadata tags are not yet supported. 

## License

libtiff uses the LibTIFF License (a BSD-like license). See the LICENSE.md file in the root directory for details.