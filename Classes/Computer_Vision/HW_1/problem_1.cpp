// problem_1.cpp

#include <iostream>
#include <fstream>
#include <cstdio>
#include "bitmap.hpp"
using namespace std;

void ReadHeader(ifstream &fin, BitmapHeader &header){
    if(!fin)
        return;
    
    fin.seekg(0, ios::beg);
    fin.read((char*) &header, sizeof(header));
}

void ReadInfoHeader(ifstream &fin, infoHeader &infoH){
    if(!fin)
        return;

    fin.read((char*) &infoH, sizeof(infoH));
}

void PrintHeader(BitmapHeader &header){
    cout << "BMP HEADER"    << endl;
    cout << "Signature  : " << header.data[0] << header.data[1] << endl;
    cout << "File Size  : " << header.fileSize << " byte(s)" << endl;
    cout << "Reserved1  : " << header.reserved1 << endl;
    cout << "Reserved2  : " << header.reserved2 << endl;
    cout << "Data Offset: " << header.dataOffset << " byte(s)" << endl;
}

void PrintInfoHeader(infoHeader &infoH){
    cout << endl;
    cout << "INFO HEADER" << endl;
    cout << "Header Size:         "         << infoH.headerSize << " byte(s)" << endl;
    cout << "Width:               "         << infoH.width << " pixel(s)" << endl;
    cout << "Height:              "         << infoH.height << " pixel(s)" << endl;
    cout << "Planes:              "         << infoH.planes << endl;
    cout << "Bit Count:           "         << infoH.bitsPerPixel << endl;
    cout << "Type of Compression: "         << infoH.compression << endl;
    cout << "Size of Image: "               << infoH.dataSize << " byte(s)" << endl;
    cout << "Pixels per Meter in X Axis: "  << infoH.XPelsPerMeter << endl;
    cout << "Pixels per Meter in Y Axis: "  << infoH.YPelsPerMeter << endl;
    cout << "Colors Used: "                 << infoH.colors << endl;
    cout << "Important Colours: "           << infoH.importantColors << endl;
}

void ReadPixels(ifstream &fin, Image &image){
    fin.seekg(54, ios::beg);
    fin.read((char*) &image, sizeof(image));
    
}

void ShowImg(Image &image){
    for(int i=0; i<10; i++){
        cout << (int)image.image[i] << endl;
    }
}


/*
int upside_down(){

    return 0
}

int right_side_left(){

    return 0
}

int diagonally_mirrored(){

    return 0
}
*/

int main(int argc, char *argv[]){
    BitmapHeader header;
    infoHeader infoH;
    Image image;

    // Read lena.bmp
    ifstream fin("lena.bmp", ios::binary);

    // Get bmp file's info
    ReadHeader(fin, header);
    ReadInfoHeader(fin, infoH);

    // Show file's info
    PrintHeader(header);
    PrintInfoHeader(infoH);

    // Read Pixels
    ReadPixels(fin, image);

    // Show imge 
    ShowImg(image);

    return 0;
}

