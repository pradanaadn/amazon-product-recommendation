from pathlib import Path
import os
import kagglehub


data_path = Path(__file__).parent.parent
os.environ["KAGGLEHUB_CACHE"] = str(data_path)
path = kagglehub.dataset_download("saurav9786/amazon-product-reviews")
print(data_path)
