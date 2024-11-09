from flask import Flask, request, jsonify
import numpy as np
from io import BytesIO
from PIL import Image
import tensorflow as tf
import base64

app = Flask(__name__)

interpreter = tf.lite.Interpreter(
    model_path=r"model.tflite"
)
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

CLASS_NAMES = [
    "Pepper__bell___Bacterial_spot",
    "Pepper__bell___healthy",
    "Potato___Early_blight",
    "Potato___Late_blight",
    "Potato___healthy",
    "Tomato_Bacterial_spot",
    "Tomato_Early_blight",
    "Tomato_Late_blight",
    "Tomato_Leaf_Mold",
    "Tomato_Septoria_leaf_spot",
    "Tomato_Spider_mites_Two_spotted_spider_mite",
    "Tomato__Target_Spot",
    "Tomato__Tomato_YellowLeaf__Curl_Virus",
    "Tomato__Tomato_mosaic_virus",
    "Tomato_healthy",
]


@app.route("/ping", methods=["GET"])
def ping():
    return "Hello, I am alive"


def read_base64_image(base64_string) -> np.ndarray:
    image_data = base64.b64decode(base64_string)
    image = Image.open(BytesIO(image_data)).convert("RGB")
    expected_shape = input_details[0]["shape"][1:3]
    image = image.resize(expected_shape, Image.LANCZOS)
    image = np.array(image)
    return image


@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    if "base64" not in data:
        return jsonify({"error": "No base64 image found in request"}), 400
    base64_string = data["base64"]
    try:
        image = read_base64_image(base64_string)
    except Exception as e:
        return jsonify({"error": f"Could not process image: {e}"}), 400
    image = np.expand_dims(image, 0).astype(np.float32)
    interpreter.set_tensor(input_details[0]["index"], image)
    interpreter.invoke()
    predictions = interpreter.get_tensor(output_details[0]["index"])[0]
    predicted_class = CLASS_NAMES[np.argmax(predictions)]
    confidence = np.max(predictions)
    print(predicted_class, " ..............", float(confidence))

    return jsonify({"class": predicted_class, "confidence": float(confidence)})


if __name__ == "__main__":
    app.run(host="0.0.0.0")
