import numpy as np
import cv2
import os

os.chdir("../img/test/")
files = os.listdir()

for file in files:
    img = cv2.imread(file, 0)
    # histogram = cv2.equalizeHist(img)
    # compare = np.concatenate((img, histogram), axis=1)

    clahe = cv2.createCLAHE(clipLimit=10.0, tileGridSize=(8,8))
    local_adative_histogram = clahe.apply(img)
    final = cv2.adaptiveThreshold(img, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 115, 1)

    compare = np.concatenate((img, final), axis=1)

    cv2.imshow ("Result", compare)
    cv2.waitKey(0)

cv2.destroyAllWindows()