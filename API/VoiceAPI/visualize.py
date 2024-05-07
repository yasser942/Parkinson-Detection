import pickle
import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
import matplotlib.pyplot as plt

def save_model_scaler(model, scaler, model_filename="model.pkl", scaler_filename="scaler.pkl"):
    with open(model_filename, 'wb') as f:
        pickle.dump(model, f)
    with open(scaler_filename, 'wb') as f:
        pickle.dump(scaler, f)
    print(f"Model and scaler saved successfully to {model_filename} and {scaler_filename}")

df = pd.read_csv('VoiceAPI\\Parkinsson disease.csv')

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

# Plot train and test accuracy for SVM and KNN classifiers
labels = ['SVM', 'KNN']
train_accuracy = [svm_train_acc, knn_train_acc]
test_accuracy = [svm_test_acc, knn_test_acc]

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
