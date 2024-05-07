import os
import pickle
import cv2
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
import matplotlib.pyplot as plt

def save_model_scaler(model, scaler, model_filename="model.pkl", scaler_filename="scaler.pkl"):
    with open(model_filename, 'wb') as f:
        pickle.dump(model, f)
    with open(scaler_filename, 'wb') as f:
        pickle.dump(scaler, f)
    print(f"Model and scaler saved successfully to {model_filename} and {scaler_filename}")

def preprocess_image(image_path, scaler):
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    image = cv2.resize(image, (64, 64))
    image = image.flatten()
    image = scaler.transform([image])
    return image

def load_data(data_dir):
    data = []
    labels = []
    for category in ["healthy", "parkinson"]:
        for dataset in ["spiral", "wave"]:
            for split in ["training", "testing"]:
                path = os.path.join(data_dir, dataset, split, category)
                for file in os.listdir(path):
                    image = cv2.imread(os.path.join(path, file), cv2.IMREAD_GRAYSCALE)
                    image = cv2.resize(image, (64, 64))
                    data.append(image.flatten())
                    labels.append(category)
    return np.array(data), np.array(labels)

data_dir = "dataset"
data, labels = load_data(data_dir)

X_train, X_test, y_train, y_test = train_test_split(data, labels, test_size=0.2, random_state=42)

scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

knn = KNeighborsClassifier(n_neighbors=3)
knn_scores = cross_val_score(knn, X_train, y_train, cv=5)
knn_mean_score = np.mean(knn_scores)
knn.fit(X_train, y_train)
knn_train_acc = knn.score(X_train, y_train)
knn_test_acc = knn.score(X_test, y_test)
print(f"KNN Cross-Validation Score: {knn_mean_score}")
print(f"KNN Train Accuracy: {knn_train_acc}")
print(f"KNN Test Accuracy: {knn_test_acc}")

svm = SVC(probability=True)
svm_scores = cross_val_score(svm, X_train, y_train, cv=5)
svm_mean_score = np.mean(svm_scores)
svm.fit(X_train, y_train)
svm_train_acc = svm.score(X_train, y_train)
svm_test_acc = svm.score(X_test, y_test)
print(f"SVM Cross-Validation Score: {svm_mean_score}")
print(f"SVM Train Accuracy: {svm_train_acc}")
print(f"SVM Test Accuracy: {svm_test_acc}")

# Plot train and test accuracy for each algorithm
labels = ['KNN', 'SVM']
train_accuracy = [knn_train_acc, svm_train_acc]
test_accuracy = [knn_test_acc, svm_test_acc]

x = np.arange(len(labels))
width = 0.35

fig, ax = plt.subplots()
rects1 = ax.bar(x - width/2, train_accuracy, width, label='Train Accuracy')
rects2 = ax.bar(x + width/2, test_accuracy, width, label='Test Accuracy')

ax.set_ylabel('Accuracy')
ax.set_title('Train and Test Accuracy by Algorithm')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()

fig.tight_layout()

plt.show()
