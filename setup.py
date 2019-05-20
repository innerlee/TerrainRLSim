from setuptools import find_packages
from distutils.core import setup, Extension
import sys, os


setup(
      #ext_modules=[Extension('terrainRLAdapter',
      #          sources=[],
      #          libraries=['_terrainRLAdapter'],
      #          runtime_library_dirs=['./lib/']
              # libraries=['X11', 'Xt']
      #        )],
    name = 'pyterrain',
    version = '0.2',
    description = 'Character simulation in Bullet Physics Engine',
    maintainer = 'Glen Berseth',
    maintainer_email = 'glen@fracturedplane.com',
    url = 'https://github.com/UBCMOCCA/TerrainRL',
    # packages=['simAdapter.terrainRLAdapter'],
    # package_dir={'terrainRLAdapter': 'terrainRLAdapter'},
    # package_data = { 'terrainRLAdapter': ['./lib/*.so'] },
    # py_modules=['simAdapter.terrainRLAdapter','simAdapter.terrainRLSim'],
    # ext_modules=[extension_mod],
    # data_files = [ ('args', need_files_args),
    #              ('data' , need_files_data) ],
    # packages=[''],
    # package_data = { '': need_files_args ,
    #                 '' : need_files_data},
    # cmdclass = {
    #     'install': MyInstall,
    #     'egg_info': MyEgg
    #     },
    # package_data = { 'args': need_files_args }
    )
