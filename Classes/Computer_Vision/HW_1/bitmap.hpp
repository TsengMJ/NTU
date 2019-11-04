// bitmap.hpp

#ifndef BITMAP_HPP
#define BITMAP_HPP

#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <stdint.h>
#endif

using namespace std;

#pragma pack(push, 2) // Align 2-bytes  

struct BitmapHeader{
    char data[2]; 
    uint32_t fileSize;
    uint16_t reserved1;
    uint16_t reserved2;
    uint32_t dataOffset;
};


struct infoHeader{
    int32_t  headerSize;           // number of bytes required 
    int32_t  width;                   // width in pixels
    int32_t  height;                  // height in pixels
                                        // if positive, it is a bottom-up DIB and it's origin is the lower left corner
                                        // if negative, it is a top-down  DIB and it's origin is the upper left corner
    uint16_t planes;       // number of color planes; must be 1
    uint16_t bitsPerPixel;     // number of bit per pixel; must be 1, 4, 8, 16, 24, 32
    uint32_t compression;    // type of compression
    uint32_t dataSize;      // size of image in bytes
    int32_t  XPelsPerMeter;           // number of pixels per meter in x axis
    int32_t  YPelsPerMeter;           // number of pixels per meter in y axis

    // both set to 255, while 16 and 24-bit image will set them to 0
    uint32_t colors;        // number of colors used
    uint32_t importantColors;   // number of colors that are important

};

#pragma pack(pop)


#pragma pack(push, 1)

struct Image{
    uint8_t image[262144];
};

#pragma pack(pop)