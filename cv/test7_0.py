#!/usr/bin/env python
import cv2
img1 = cv2.imread('messi5.jpg')
img2 = cv2.imread('messi6.jpg')
print img1.size
print img2.size
dst = cv2.addWeighted(img1,0.3,img2,0.7,0)
cv2.imshow('dst',dst)
cv2.waitKey(0)
cv2.destroyAllWindows()
