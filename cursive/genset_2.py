from glob import glob
from random import randrange
from os import mkdir, chdir
from shutil import rmtree, copyfile
import tensorflow as tf
from tensorflow.keras import datasets, layers, models
import numpy as np
import matplotlib.pyplot as plt
import pathlib
# Find characters that has more than one image
# Pick random character and remove it from the array

IMG_WIDTH = IMG_HEIGHT = 80
data_dir = pathlib.Path("gen_train")
CLASS_NAMES = np.array([item.name[0] for item in pathlib.Path("gen_test").glob('*')])
print(CLASS_NAMES)

image_count = len([item.name for item in data_dir.glob('*')])
image_generator = tf.keras.preprocessing.image.ImageDataGenerator(rescale=1./255)
BATCH_SIZE = 32
IMG_HEIGHT = 80
IMG_WIDTH = 80
STEPS_PER_EPOCH = np.ceil(image_count/BATCH_SIZE)
train_data_gen = image_generator.flow_from_directory(directory='gen_train',
                                                     batch_size=BATCH_SIZE,
                                                     shuffle=True,
                                                     target_size=(IMG_HEIGHT, IMG_WIDTH),
                                                     classes = list(CLASS_NAMES))

def show_batch(image_batch, label_batch):
  plt.figure(figsize=(10,10))
  for n in range(25):
      ax = plt.subplot(5,5,n+1)
      plt.imshow(image_batch[n])
      plt.title(CLASS_NAMES[label_batch[n]==1][0].title()) #label_batch[n])
      plt.axis('off')
  plt.show()

image_batch, label_batch = next(train_data_gen)
show_batch(image_batch, label_batch)
# def decode_img(img):
#   # convert the compressed string to a 3D uint8 tensor
#   img = tf.image.decode_jpeg(img, channels=3)
#   # Use `convert_image_dtype` to convert to floats in the [0,1] range.
#   img = tf.image.convert_image_dtype(img, tf.float32)
#   img = 1 - img
#   # resize the image to the desired size.
#   return tf.image.resize_with_pad(img, IMG_WIDTH, IMG_HEIGHT)

# def prepare_for_training(ds, cache=True, shuffle_buffer_size=1000):
#   # This is a small dataset, only load it once, and keep it in memory.
#   # use `.cache(filename)` to cache preprocessing work for datasets that don't
#   # fit in memory.
#   if cache:
#     if isinstance(cache, str):
#       ds = ds.cache(cache)
#     else:
#       ds = ds.cache()

#   ds = ds.shuffle(buffer_size=shuffle_buffer_size)

#   # Repeat forever
#   ds = ds.repeat()

#   ds = ds.batch(32)

#   # `prefetch` lets the dataset fetch batches in the background while the model
#   # is training.
#   ds = ds.prefetch(buffer_size=-1)

#   return ds

# def process_path(file_path):
#   label = tf.strings.substr(tf.strings.split(file_path, '\\')[-1], 0, 3) == CLASS_NAMES
#   # load the raw data from the file as a string
#   img = tf.io.read_file(file_path)
#   img = decode_img(img)
#   print(img)
#   return img, label

# def show_batch(image_batch, label_batch):
#   plt.figure(figsize=(10,10))
#   for n in range(25):
#       ax = plt.subplot(5,5,n+1)
#       plt.imshow(image_batch[n])
#       plt.title(CLASS_NAMES[label_batch[n]==1][0].title()) #label_batch[n])
#       plt.axis('off')
#   plt.show()

# # list_ds = glob('gen_train/*') #glob('gen_train/*') #
# # labeled_ds = np.array([process_path(x) for x in list_ds])
# # print(labeled_ds.take(1))

# list_ds = tf.data.Dataset.list_files('gen_train/*')
# for f in list_ds.take(5):
#   print(f.numpy())
# labeled_ds = list_ds.map(process_path) #, num_parallel_calls=AUTOTUNE)
# for image, label in labeled_ds.take(1):
#   print("Image shape: ", image.numpy().shape)
#   print("Label: ", label.numpy())
# train_ds = prepare_for_training(labeled_ds)

# t_list_ds = tf.data.Dataset.list_files('gen_train/*')
# t_labeled_ds = t_list_ds.map(process_path) #, num_parallel_calls=AUTOTUNE)
# t_train_ds = prepare_for_training(t_labeled_ds)

model = models.Sequential()
model.add(layers.Conv2D(70, (3, 3), activation='relu', input_shape=(80, 80, 3)))
model.add(layers.MaxPooling2D((2, 2)))
# model.add(layers.Conv2D(64, (3, 3), activation='relu'))
# model.add(layers.MaxPooling2D((2, 2)))
# model.add(layers.Conv2D(64, (3, 3), activation='relu'))
# model.add(layers.Flatten())
# model.add(layers.Dense(64, activation='relu'))
# model.add(layers.Dense(10, activation='softmax'))
model.summary()

model.compile(optimizer='adam',
              loss='mean_squared_error',
              metrics=['accuracy'])

# image_batch, label_batch = next(iter(train_ds))
# t_image_batch, t_label_batch = next(iter(t_train_ds))
# show_batch(image_batch.numpy(), label_batch.numpy())

image_batch, label_batch = next(train_data_gen)
show_batch(image_batch, label_batch)

history = model.fit(image_batch, label_batch, epochs=10)







# ------------------------------------------------------------
rmtree('gen_train',True)
rmtree('gen_test',True)
mkdir('gen_train')
mkdir('gen_test')

a = []
b = []
for x in glob('*.png'):
	if x[1] == '0':
		b.append(a)
		a = []
	a.append(x)
b.pop(0)
a = []
for x in reversed(range(len(b))):
	if len(b[x]) > 1:
		a.append(b.pop(x))
print(a)
print(b)

for x in range(len(a)):
	y = a[x].pop(randrange(len(a[x])))
	chdir('gen_test')
	try:
		mkdir(y[0])
	except Exception as e:
		pass
	chdir('..')

	chdir('gen_train')
	try:
		mkdir(y[0])
	except Exception as e:
		pass
	chdir('..')

	copyfile(y, 'gen_test/'+y[0]+'/'+y)
	for y in a[x]:
		copyfile(y, 'gen_train/'+y[0]+'/'+y)
print(a)

# from skimage import data
# from skimage import transform as tf
# from skimage.feature import (match_descriptors, corner_peaks, corner_harris,
#                              plot_matches, BRIEF)
# from skimage.color import rgb2gray
# import matplotlib.pyplot as plt



# img1 = rgb2gray(data.astronaut())
# tform = tf.AffineTransform(scale=(1.2, 1.2), translation=(0, -100))
# img2 = tf.warp(img1, tform)
# img3 = tf.rotate(img1, 25)

# keypoints1 = corner_peaks(corner_harris(img1), min_distance=5)
# keypoints2 = corner_peaks(corner_harris(img2), min_distance=5)
# keypoints3 = corner_peaks(corner_harris(img3), min_distance=5)

# extractor = BRIEF()

# extractor.extract(img1, keypoints1)
# keypoints1 = keypoints1[extractor.mask]
# descriptors1 = extractor.descriptors

# extractor.extract(img2, keypoints2)
# keypoints2 = keypoints2[extractor.mask]
# descriptors2 = extractor.descriptors

# extractor.extract(img3, keypoints3)
# keypoints3 = keypoints3[extractor.mask]
# descriptors3 = extractor.descriptors

# matches12 = match_descriptors(descriptors1, descriptors2, cross_check=True)
# matches13 = match_descriptors(descriptors1, descriptors3, cross_check=True)

# fig, ax = plt.subplots(nrows=2, ncols=1)

# plt.gray()

# plot_matches(ax[0], img1, img2, keypoints1, keypoints2, matches12)
# ax[0].axis('off')
# ax[0].set_title("Original Image vs. Transformed Image")

# plot_matches(ax[1], img1, img3, keypoints1, keypoints3, matches13)
# ax[1].axis('off')
# ax[1].set_title("Original Image vs. Transformed Image")


# plt.show()