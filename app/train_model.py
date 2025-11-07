from sklearn.linear_model import LinearRegression
from sklearn.datasets import load_diabetes
import pickle

X, y = load_diabetes(return_X_y=True)
model = LinearRegression()
model.fit(X, y)

pickle.dump(model, open("model.pkl", "wb"))
print("✅ Model trained and saved as model.pkl")
