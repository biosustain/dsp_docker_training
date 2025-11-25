import pandas as pd

a = pd.read_csv("/data/in/input.csv")
print(a)
print()

b = a.copy()
b["Age"] = b["Age"] * 2

b.to_csv("/data/out/output.csv")
print(b)

# Using separate folders for input and output: input data is safe from unintended
# writes.

# docker run \
#   -u `id -u`:`id -g` \
#   -v ./007_bind_mounts_in_out/my_data/in:/data/in:ro \
#   -v ./007_bind_mounts_in_out/my_data/out:/data/out \
#   training:007
