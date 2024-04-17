# syntax=docker/dockerfile:experimental
FROM python:3.11-bookworm
RUN apt-get update && apt-get -y --no-install-recommends install libgomp1 wget
ENV APP_HOME /app
# install Java
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update -y && \
    apt-get install -y openjdk-17-jre-headless
# install essential packages
RUN apt-get install -y \
    libxml2-dev libxslt-dev \
    build-essential libmagic-dev
# install tesseract
# RUN apt-get install -y \
#     tesseract-ocr \
#     lsb-release \
#     && echo "deb https://notesalexp.org/tesseract-ocr5/$(lsb_release -cs)/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/notesalexp.list > /dev/null \
#     && apt-get update -oAcquire::AllowInsecureRepositories=true \
#     && apt-get install notesalexp-keyring -oAcquire::AllowInsecureRepositories=true -y --allow-unauthenticated \
#     && apt-get update \
#     && apt-get install -y \
#     tesseract-ocr libtesseract-dev \
#     && wget -P /usr/share/tesseract-ocr/5/tessdata/ https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata
RUN apt-get install unzip -y && \
    apt-get install git -y && \
    apt-get autoremove -y
WORKDIR ${APP_HOME}
COPY . ./
RUN pip install --upgrade pip setuptools
RUN apt-get install -y libmagic1 && rm -rf /var/lib/apt/lists/*
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir -p /usr/local/nltk_data/corpora && wget "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/stopwords.zip" -O /usr/local/nltk_data/corpora/stopwords.zip
RUN cd /usr/local/nltk_data/corpora && unzip stopwords.zip
RUN mkdir -p /usr/local/nltk_data/tokenizers && wget "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt.zip" -O /usr/local/nltk_data/tokenizers/punkt.zip
RUN cd /usr/local/nltk_data/tokenizers && unzip punkt.zip
RUN chmod +x run.sh
CMD ./run.sh