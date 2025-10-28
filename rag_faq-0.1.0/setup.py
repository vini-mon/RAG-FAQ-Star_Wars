# setup.py (CORRIGIDO com package_data)
from setuptools import setup, find_packages

setup(
    name="rag-faq", 
    version="0.1.0", 
    packages=find_packages(), 
    include_package_data=True,
    package_data={ 
        "rag_faq": ["prompts/*.txt"], 
    },
)