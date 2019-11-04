import cv2

def upside_down(img):
    img_ud = img.copy()
    h, w = img.shape[:2]
    
    for i in range(int(h/2)):
        index = h - i - 1
        tmp = img_ud[i].copy()
        img_ud[i] = img_ud[index]
        img_ud[index] = tmp

    return img_ud

def right_side_left(img):
    img_rsl = img.copy()
    h, w = img.shape[:2]

    for i,row in enumerate(img_rsl):
        for j in range(int(w/2)):
            index = w - j - 1
            tmp = img_rsl[i,j].copy()
            img_rsl[i, j] = img_rsl[i, index]
            img_rsl[i, index] = tmp

    return img_rsl

def diagonally_mirrored(img):
    img_dm = img.copy()
    h, w = img.shape[:2]    

    for i in range(h):
        for j in range(h-i):
            y = h - j - 1
            x = w - i - 1

            tmp = img_dm[i,j].copy()
            img_dm[i,j] = img_dm[y,x]
            img_dm[y,x] = tmp

    return img_dm

if __name__ == "__main__":
    img_ori = cv2.imread("lena.bmp")

    img_ud  = upside_down(img_ori)
    img_rsl = right_side_left(img_ori)
    img_dm  = diagonally_mirrored(img_ori)

    cv2.imwrite("lena_upside_down.jpg", img_ud)
    cv2.imwrite("lena_right_side_left.jpg", img_rsl)
    cv2.imwrite("lena_diag_mirror.jpg", img_dm)