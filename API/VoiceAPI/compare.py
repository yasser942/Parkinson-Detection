import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
from flask import Flask, request, jsonify
import pickle

def save_model_scaler(model, scaler, model_filename="model.pkl", scaler_filename="scaler.pkl"):
    with open(model_filename, 'wb') as f:
        pickle.dump(model, f)
    with open(scaler_filename, 'wb') as f:
        pickle.dump(scaler, f)
    print(f"Model and scaler saved successfully to {model_filename} and {scaler_filename}")

df = pd.read_csv('VoiceAPI\\Parkinsson disease.csv')
df['status'].value_counts()

x = df.drop(columns=['status', 'name'])
y = df['status']

scaler = StandardScaler()
x_std = scaler.fit_transform(x)

x_train, x_test, y_train, y_test = train_test_split(x_std, y, test_size=0.2, stratify=y, random_state=2)

# Train the SVM classifier
svm = SVC(kernel='linear')
svm.fit(x_train, y_train)
svm_train_acc = accuracy_score(y_train, svm.predict(x_train))
svm_test_acc = accuracy_score(y_test, svm.predict(x_test))
print(f"SVM Training Accuracy: {svm_train_acc}")
print(f"SVM Testing Accuracy: {svm_test_acc}")

# Train the KNN classifier
knn = KNeighborsClassifier(n_neighbors=3)
knn.fit(x_train, y_train)
knn_train_acc = accuracy_score(y_train, knn.predict(x_train))
knn_test_acc = accuracy_score(y_test, knn.predict(x_test))
print(f"KNN Training Accuracy: {knn_train_acc}")
print(f"KNN Testing Accuracy: {knn_test_acc}")

# Compare accuracies and save the model with higher accuracy
if svm_test_acc > knn_test_acc:
    save_model_scaler(svm, scaler, model_filename="VoiceAPI\\best_model.pkl", scaler_filename="VoiceAPI\\best_scaler.pkl")
    print("SVM model saved as the best model.")
else:
    save_model_scaler(knn, scaler, model_filename="VoiceAPI\\best_model.pkl", scaler_filename="VoiceAPI\\best_scaler.pkl")
    print("KNN model saved as the best model.")

app = Flask(__name__)

@app.route('/predict/voice', methods=['POST'])
def predict():
    data = request.get_json()
    if not isinstance(data, list):
        return jsonify({'error': 'Invalid input format. Please provide a list of numerical values.'}), 400
    if not all(isinstance(val, (int, float)) for val in data):
        return jsonify({'error': 'Invalid input data. Please provide only numerical values.'}), 400
    input_data_array = np.asarray(data)
    input_data_reshape = input_data_array.reshape(1, -1)
    model = pickle.load(open('best_model.pkl', 'rb'))
    scaler = pickle.load(open('best_scaler.pkl', 'rb'))
    std_data = scaler.transform(input_data_reshape)
    prediction = model.predict(std_data)[0]
    return jsonify({'prediction': int(prediction)})

if __name__ == '__main__':
    app.run(host="192.168.1.113",debug=True, port=5001, threaded=False)
