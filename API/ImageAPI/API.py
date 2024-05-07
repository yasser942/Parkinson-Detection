from flask import Flask, request, jsonify
import cv2
import joblib
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC  # Import SVM Classifier
from flask_cors import CORS 
import os

app = Flask(__name__)
CORS(app)

# Load your trained model and scaler here
svm = joblib.load('ImageAPI\\best_model.pkl')  # Load SVM model
scaler = joblib.load('ImageAPI\\best_scaler.pkl')  # Load scaler

@app.route('/predict/image', methods=['POST'])
def predict():
    file = request.files['image']
    if not file:
        return jsonify({'error': 'no file'})
    
    # Read the image file to a numpy array
    img = cv2.imdecode(np.frombuffer(file.read(), np.uint8), cv2.IMREAD_UNCHANGED)
    
    # Preprocess the image (resize, grayscale, flatten, normalize)
    img = cv2.resize(img, (64, 64))
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    img = img.flatten()
    img = scaler.transform([img])
    
    # Make a prediction
    prediction = svm.predict(img)
    
    # Get the probabilities of each class
    probabilities = svm.predict_proba(img)
    
    # Create a dictionary mapping class labels to probabilities
    probabilities_dict = dict(zip(svm.classes_, probabilities[0]))
    
    # Return the prediction and probabilities
    return jsonify({'prediction': prediction[0], 'probabilities': probabilities_dict})

if __name__ == '__main__':
    app.run(host="192.168.1.112",debug=True, port=5001, threaded=False)
