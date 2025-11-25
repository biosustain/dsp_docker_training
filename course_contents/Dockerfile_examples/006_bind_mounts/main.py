import pandas as pd

a = pd.read_csv("/data/input.csv")
print(a)
print()

b = a.copy()
b["Age"] = b["Age"] * 2

b.to_csv("/data/output.csv")
print(b)

# Input and output files are in the same folder. Not ideal: it would be better
# to have the data folder safe from unintended writes.

# docker run \
#   -u `id -u`:`id -g` \
#   -v ./006_bind_mounts/my_data:/data \
#   training:006
