from glob import glob
from skimage.io import imread, imsave
from skimage.morphology import skeletonize, medial_axis, thin
import matplotlib.pyplot as plt
from skimage.util import invert

for x in glob('cursive/*.png'):
	im = imread(x, as_gray=True)
	im = invert(im)
	im2 = skeletonize(im)
	im3 = medial_axis(im)
	im4 = thin(im)
	plt.imsave(x.replace('cursive','skeletonized'), invert(im4), cmap=plt.cm.gray)

# fig, axes = plt.subplots(nrows=1, ncols=3, figsize=(8, 4),
#                          sharex=True, sharey=True)

# ax = axes.ravel()
# ax[0].imshow(invert(im), cmap=plt.cm.gray)
# ax[1].imshow(invert(im2), cmap=plt.cm.gray)
# ax[2].imshow(invert(im3), cmap=plt.cm.gray)

# plt.show()