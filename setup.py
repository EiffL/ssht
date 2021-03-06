import sys
import os
import shutil

from distutils.core import setup, Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize

import numpy

# clean previous build
for root, dirs, files in os.walk("./src/python/", topdown=False):
    for name in dirs:
        if (name == "build"):
            shutil.rmtree(name)


include_dirs = [
    numpy.get_include(),
    "./include",
    "./include/c",
    ]

extra_link_args=[
    "-L./lib/c",
    "-L"+os.environ['FFTW']+"/lib",
]

setup(
    classifiers=['Programming Language :: Python :: 2.7'],
    name = "pyssht",
    version = "2.0",
    package_dir={'':'src/python'},
    packages=['pyssht'],
    cmdclass={'build_ext': build_ext},
    ext_modules=cythonize([Extension(
        "pyssht.pyssht",
        sources=["src/python/pyssht/pyssht.pyx"],
        include_dirs=include_dirs,
        libraries=["ssht", "fftw3"],
        extra_link_args=extra_link_args,
        extra_compile_args=[]
    )])
)
