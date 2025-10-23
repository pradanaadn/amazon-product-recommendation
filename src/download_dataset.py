from pathlib import Path
import os
import kagglehub


data_path = Path(__file__).parent.parent
os.environ["KAGGLEHUB_CACHE"] = str(data_path)

print(data_path)
