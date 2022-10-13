from setuptools import setup, find_packages

with open("README.md", "r") as f:
    page_description = f.read()

with open("requirements.txt") as f:
    requirements = f.read().splitlines()

setup(
    name="pacote_processamento_img",
    version="0.0.1",
    author="joao_pedro_ps",
    author_email="jpperes@gmail.com",
    description="projeto_desenvolvido_durante_aoda_de_processamento_de_imagens",
    long_description=page_description,
    long_description_content_type="text/markdown",
    url="https://github.com/joaopedroperes-web/pacote-processamento-imagem",
    packages=find_packages(),
    install_requires=requirements,
    python_requires='>=3.8'
)