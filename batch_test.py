import os
import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing import image

model = tf.keras.models.load_model("model.h5")

class_names = ["apple_scab", "black_rot", "healthy", "rust"]

folder_path = "test_images"

for img_name in os.listdir(folder_path):

    img_path = os.path.join(folder_path, img_name)

    img = image.load_img(img_path, target_size=(224, 224))
    img = image.img_to_array(img)
    img = np.expand_dims(img, axis=0) / 255.0

    pred = model.predict(img)

    result = class_names[np.argmax(pred)]
    confidence = np.max(pred) * 100

    print(img_name, "→", result, f"({confidence:.2f}%)")
