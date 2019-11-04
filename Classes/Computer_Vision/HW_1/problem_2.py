import cv2
import imutils
import os

def rotate(img, angle):
    img_rotate = imutils.rotate_bound(img, angle)

    return img_rotate


def shrink_half(img):
    H, W = img.shape[:2]
    H = int(H/2)
    W = int(W/2)
    img_shrink = cv2.resize(img, (H, W))

    return img_shrink

def binarize(img, threshold):
    _, img_binarize = cv2.threshold(img,threshold,255,cv2.THRESH_BINARY)

    return img_binarize


if __name__ == "__main__":
    ## Read img
    img_ori = cv2.imread("lena.bmp", 0) 

    ## Get rotate_file
    img_rotate = rotate(img_ori, 45)

    ## Get shrink file
    img_shrink = shrink_half(img_ori)

    ## Get binarize file
    img_binarize = binarize(img_ori, 128)

    ## Savimg img
    cv2.imwrite("lena_rotate.jpg", img_rotate)
    cv2.imwrite("lena_shrink.jpg", img_shrink)
    cv2.imwrite("lena_binarize.jpg", img_binarize)
    