import numpy as np
import pandas as pd

def use_numpy():
    a = np.array([[1, 2, 3],
                [4, 5, 6]])
    result = a * 2
    print(result)

def use_pandas():
    df = pd.DataFrame(
        {
            "Name": ["Anna", "Bob", "Carl", "Daniel"],
            "Age": [23, 28, 27, 33],
        }
    )
    avg_age = df["Age"].mean()
    print(avg_age)

use_numpy()
use_pandas()
