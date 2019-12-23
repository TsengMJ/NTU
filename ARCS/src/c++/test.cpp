#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

int main(int argc, char** argv)
{
//  // Read the image file
    cv::Mat image = cv::imread("/home/mj/HardDisk/Github/NTU/ARCS/img/X-Ray/Test/avg_19.bmp");

    cout << "OpenCV version : " << CV_VERSION << endl;


 return 0;
}