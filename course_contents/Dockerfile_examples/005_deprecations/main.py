import numpy as np

a = np.array([[1, 2, 3], [4, 5, 6]], np.int32)
b = a.tostring()
print(b)

# See "Expired deprecations" at https://numpy.org/doc/stable/release.html

# NumPy is not strictly following semantic versioning (SemVer). While SemVer
# would reserve breaking changes for major version increments, in practice NumPy
# sometimes removes deprecated features in a minor version.
