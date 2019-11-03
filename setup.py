"""Detroit Black Tech Web Portal
See:
https://packaging.python.org/en/latest/distributing.html
https://github.com/pypa/sampleproject
"""

# Always prefer setuptools over distutils
from setuptools import setup, find_packages
# To use a consistent encoding
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='dbt_webportal',  # Required
    version='0.0.1',  # Required
    maintainer='Detroit Black Tech',
    maintainer_email='hello@detroitblacktech.com',
    description='Detroit Black Technologists Web Presence',  # Required
    long_description=long_description,  # Optional
    url='https://github.com/detroitblacktech/webportal',  # Optional
    classifiers=[  # Optional
        'Development Status :: 2 - Pre-Alpha',
        'Environment :: Web Environment',
        'Framework :: Flask',
        'Intended Audience :: End Users/Desktop',
        'Programming Language :: Python :: 3.4', # TODO: we currently can't go past 3.6 because 3.7 conflicts with util/decorator.py#async
    ],
    keywords='detroit black tech',  # Optional
    packages=find_packages(exclude=["tests/*"]),  # Required
    install_requires=[
        'flask-restplus',
        'Flask-SQLAlchemy==2.1',
        'sqlalchemy_utils',
        'flask_cors',
        'requests',
        'jinja2',
        'Flask-Script',
        'mysqlclient',
        'kafka-python'
    ],  # Optional
    extras_require={  # Optional
        'test': ['black', 'pipenv', 'tox', 'tox-pipenv', 'coverage'],
    }
)
