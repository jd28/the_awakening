# setup.py for neverrun

from distutils.core import setup
import os

print(os.name)

samples = [os.path.join('samples', i) for i in os.listdir('samples')]
twodxs = [os.path.join('2dx', i) for i in os.listdir('2dx')]

data_files = [('samples', samples),
              ('2dx', twodxs),
              ('', ['2dasource.zip'])]

if os.name == 'nt':
    import py2exe
    setup(name="2dilate",
          version="0.2",
          description="A different kind of 2da merger.",
          author="jmd",
          data_files = data_files,
          console = [ {
              "script": "2dilate.py"}])

elif os.name == 'posix':
    setup(name="2dilate",
          version="0.2",
          description="A different kind of 2da merger.",
          author="jmd",
          packages = ['src'],
          data_files = data_files,
          scripts = ['2dilate.py'])
