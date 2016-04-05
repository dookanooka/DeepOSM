# https://hub.docker.com/r/homme/gdal/
FROM geodata/gdal

# geodata/gdal sets the user to noboby so re-set to root
USER root

# Install pythons and setup virtualenv, from https://github.com/GoogleCloudPlatform/python-docker/blob/master/Dockerfile
RUN apt-get -q update && \
 apt-get install --no-install-recommends -y -q \
   libbz2-dev python2.7 python2.7-dev cmake python-pip build-essential git mercurial \
   libffi-dev libssl-dev libxml2-dev \
   libxslt1-dev libpq-dev libmysqlclient-dev libcurl4-openssl-dev \
   libjpeg-dev zlib1g-dev libpng12-dev \
   gfortran libblas-dev liblapack-dev libatlas-dev libquadmath0 \
   libfreetype6-dev pkg-config swig \
   zlib1g-dev libshp-dev libsqlite3-dev \
   libgd2-xpm-dev libexpat1-dev libgeos-dev libgeos++-dev libxml2-dev \
   libsparsehash-dev libv8-dev libicu-dev libgdal1-dev \
   libprotobuf-dev protobuf-compiler devscripts debhelper \
   fakeroot doxygen libboost-dev libboost-all-dev git-core \
   && \
 apt-get clean

# Copy requirements.txt and run pip to install all
# dependencies into the virtualenv.
ADD requirements.txt /Deep-OSM/requirements.txt
RUN pip install -r /Deep-OSM/requirements.txt
RUN ln -s /home/vmagent/naipreader /Deep-OSM

# install libosmium and pyosmium bindings
RUN git clone https://github.com/osmcode/libosmium /libosmium
RUN cd /libosmium && mkdir build && cd build && cmake .. && make
RUN git clone https://github.com/osmcode/pyosmium.git /pyosmium
RUN cd /pyosmium && pwd && python setup.py install

ADD . /Deep-OSM
WORKDIR /Deep-OSM
