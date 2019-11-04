import matplotlib.pyplot as plt
import numpy as np
import os
import cv2

def threshold(img, thresh_value):
    tmp = img.copy()
    height, width= tmp.shape[:2]

    for i in range(height):
        for j in range(width):
            if (tmp[i][j][0] <= thresh_value):
                tmp[i,j,:] = 0
            else:
                tmp[i,j,:] = 255

    return tmp[:,:,0]

def histogram(img):
    tmp = img.copy()
    histo = [0]*256
    dictionary = {}
    height, width= tmp.shape[:2]

    for i in range(height):
        for j in range(width):
            value = tmp[i][j][0]
            histo[value] += 1

    for i in range(256):
        dictionary[str(i)] = histo[i]

    return dictionary

def connected_component(gray, img):
    test = img.copy()
    tmp = np.zeros([514,514], dtype = int)
    height, width= img.shape[:2]


    # Initialize
    label = 1
    for i in range(0, height):
        for j in range(0, width):
            if gray[i,j] == 255:
                tmp[i+1,j+1] = label
                label += 1
    
    # Iterative
    keep_going = True
    a = 1
    while(keep_going):
        keep_going = False

        print(a)
        a += 1

        # Top-down
        for i in range(1, height+1):
            for j in range(1, width+1):
                if tmp[i,j]!=0:
                    current = tmp[i,j]
                    left = tmp[i,j-1]
                    top = tmp[i-1,j]

                    if left != 0 and left < current:
                        tmp[i,j] = left
                        current = left
                        keep_going = True
                    
                    if top != 0 and top < current:
                        tmp[i,j] = top
                        current = top
                        keep_going = True

        # Buttom-up
        for i in range(height, 0, -1):
            for j in range(width, 0, -1):
                if tmp[i,j]!=0:
                    current = tmp[i,j]
                    right = tmp[i,j+1]
                    down = tmp[i+1,j]

                    if right != 0 and right < current:
                        tmp[i,j] = right
                        current = right
                        keep_going = True
                    elif down != 0 and down < current:
                        tmp[i,j] = down
                        current = down
                        keep_going = True    

    # Find bounding-box
    comps = {}  # [totals, cs, cy, min_x, min_y, max_x, max_y]

    for i in range(1, height+1):
        for j in range(1, width+1):
            if tmp[i,j] == 0:
                continue

            current = tmp[i,j]
            index = str(current)
            if not index in comps:
                comps[index] = {'numbers':1, 'cx':i, 'cy':j, 'min_x':i, 'min_y':j, 'max_x':i, 'max_y':j}
            else:
                number = comps[index]['numbers']

                comps[index]['numbers'] = number + 1
                comps[index]['cx'] = comps[index]['cx']*number/(number+1) + i/(number+1)
                comps[index]['cy'] = comps[index]['cy']*number/(number+1) + j/(number+1)

                if comps[index]['min_x'] > i: comps[index]['min_x'] = i
                if comps[index]['min_y'] > j: comps[index]['min_y'] = j
                if comps[index]['max_x'] < i: comps[index]['max_x'] = i
                if comps[index]['max_y'] < j: comps[index]['max_y'] = j

    for i in comps:
        if comps[i]['numbers'] > 500:
            cv2.rectangle(test, (int(comps[i]['min_y']), int(comps[i]['min_x'])), (int(comps[i]['max_y']), int(comps[i]['max_x'])), (0, 0, 255), 1)
            cv2.circle(test,(int(comps[i]['cy']), int(comps[i]['cx'])), 2, (255, 0, 0), -1)


    return test

if __name__ == "__main__":
    img = cv2.imread("lena.bmp")
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # Threshold at 128
    thresh = threshold(img, 128)
    cv2.imwrite("threshed.png", thresh)

    dic = histogram(img)
    ## Use plt to print out the fig
    # plt.hist(gray.ravel(), bins=256, range=[0, 256])
    plt.hist(list(dic.keys()), weights=list(dic.values()), bins=256)
    plt.savefig("histo.png")

    test = connected_component(thresh, img)
    cv2.imwrite("connected.png", test)
    # cv2.imshow("Ori", img)
    cv2.imshow("Gray", gray)
    cv2.imshow("Test", test)
    cv2.imshow("Thresh", thresh)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
