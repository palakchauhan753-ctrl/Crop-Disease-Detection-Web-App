
from dotenv import load_dotenv
from flask import Flask, request, jsonify
from flask_cors import CORS

import tensorflow as tf
import numpy as np
from tensorflow.keras.preprocessing import image

import os
import requests

load_dotenv()

app = Flask(__name__)


# ✅ ENABLE CORS
CORS(app)

# =====================================================
# 🔥 LOAD MODEL
# =====================================================

model = tf.keras.models.load_model("model.h5")

# =====================================================
# 🌿 CLASS LABELS
# =====================================================

labels = [
    "apple_scab",
    "black_rot",
    "healthy",
    "rust"
]

# =====================================================
# ⭐ HISTORY STORAGE
# =====================================================

history_data = []

# =====================================================
# 🌿 SOLUTION FUNCTION
# =====================================================

def get_solution(disease):

    solutions = {

        "apple_scab":
            "Use fungicide spray and remove infected leaves.",

        "black_rot":
            "Remove infected fruits and use proper fungicides.",

        "healthy":
            "Plant is healthy. Continue proper care.",

        "rust":
            "Use sulfur spray and avoid excess moisture."
    }

    return solutions.get(
        disease,
        "No solution available"
    )

# =====================================================
# 🌿 DISEASE PREDICTION API
# =====================================================

@app.route('/predict', methods=['POST'])
def predict():

    try:

        # IMAGE RECEIVE
        file = request.files['image']

        # TEMP SAVE
        #filepath = "temp.jpg"

        #file.save(filepath)

        filepath = os.path.join(
            "uploads",
            file.filename
        )
        file.save(filepath)

        # IMAGE PREPROCESS
        img = image.load_img(
            filepath,
            target_size=(224, 224)
        )

        img_array = image.img_to_array(img)

        img_array = np.expand_dims(
            img_array,
            axis=0
        ) / 255.0

        # PREDICTION
        predictions = model.predict(img_array)

        predicted_index = np.argmax(predictions)

        disease = labels[predicted_index]

        confidence = float(
            np.max(predictions) * 100
        )

        # GET SOLUTION
        solution = get_solution(disease)

        # DELETE TEMP FILE
        os.remove(filepath)

        # RETURN RESPONSE
        return jsonify({

            "disease": disease,

            "confidence": round(
                confidence,
                2
            ),

            "solution": solution
        })

    except Exception as e:

        return jsonify({

            "error": str(e)

        })

# =====================================================
# ⭐ SAVE HISTORY API
# =====================================================

@app.route('/save_history', methods=['POST'])
def save_history():

    try:

        data = request.json

        history_data.append(data)

        return jsonify({

            "message":
                "History saved successfully"

        })

    except Exception as e:

        return jsonify({

            "error": str(e)

        })

# =====================================================
# 📜 GET HISTORY API
# =====================================================

@app.route('/history', methods=['GET'])
def get_history():

    return jsonify(history_data)

# =====================================================
# ☁ WEATHER API
# =====================================================

@app.route('/weather_api', methods=['GET'])
def weather_api():

    city = request.args.get("city")

    return jsonify({

        "city": city,

        "temperature": 28,

        "humidity": 65,

        "condition": "Cloudy"

    })

# =====================================================
# 🏠 HOME ROUTE
# =====================================================

@app.route('/')
def home():

    return "Crop Disease Backend Running Successfully"

# =====================================================
# 🚀 RUN SERVER
# =====================================================

if __name__ == "__main__":

    app.run(

        host="0.0.0.0",

        port=5000,

        debug=True
    )
