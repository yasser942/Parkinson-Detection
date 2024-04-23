import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score
from flask import Flask, request, jsonify
import pickle

# Define function to save the model and scaler
def save_model_scaler(model, scaler, model_filename="model.pkl", scaler_filename="scaler.pkl"):
    """Saves the trained model and scaler to pickle files.

    Args:
        model: The trained model object.
        scaler: The fitted scaler object.
        model_filename: The filename to save the model (default: "model.pkl").
        scaler_filename: The filename to save the scaler (default: "scaler.pkl").
    """
    with open(model_filename, 'wb') as f:
        pickle.dump(model, f)
    with open(scaler_filename, 'wb') as f:
        pickle.dump(scaler, f)
    print(f"Model and scaler saved successfully to {model_filename} and {scaler_filename}")

# Load the data
df = pd.read_csv('VoiceAPI\\Parkinsson disease.csv')

# Preprocessing steps (same as before)
#df.head()
#df.shape
#df.describe()
#df.info()
df['status'].value_counts()

x = df.drop(columns=['status', 'name'])
y = df['status']

scaler = StandardScaler()
x_std = scaler.fit_transform(x)

x_train, x_test, y_train, y_test = train_test_split(x_std, y, test_size=0.2, stratify=y, random_state=2)

model = SVC(kernel='linear')

model.fit(x_train, y_train)

# Print training and testing accuracy
print("Training accuracy:", accuracy_score(model.predict(x_train), y_train))
print("Testing accuracy:", accuracy_score(model.predict(x_test), y_test))

# Save the model and scaler
save_model_scaler(model, scaler)

# Flask API starts here
app = Flask(__name__)

@app.route('/predict/voice', methods=['POST'])
def predict():
    # Get the input data from the request
    data = request.get_json()

    # Validate the input data format
    if not isinstance(data, list):
        return jsonify({'error': 'Invalid input format. Please provide a list of numerical values.'}), 400

    # Check if all values are numerical
    if not all(isinstance(val, (int, float)) for val in data):
        return jsonify({'error': 'Invalid input data. Please provide only numerical values.'}), 400

    # Convert the input data to a NumPy array
    input_data_array = np.asarray(data)

    # Reshape the array
    input_data_reshape = input_data_array.reshape(1, -1)

    # **Load the model and scaler (after validation)**
    model = pickle.load(open('model.pkl', 'rb'))
    scaler = pickle.load(open('scaler.pkl', 'rb'))

    # Standardize the data using the loaded scaler
    std_data = scaler.transform(input_data_reshape)

    # Make the prediction
    prediction = model.predict(std_data)[0]

    return jsonify({'prediction': int(prediction)})

if __name__ == '__main__':
    app.run(host="192.168.1.113",debug=True, port=5001, threaded=False)
