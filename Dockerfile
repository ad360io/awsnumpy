# 2018 QChain Inc. All Rights Reserved.
# License: Apache v2, see LICENSE.

FROM amazonlinux:latest

# Configuration options
ARG python_runtime=36
ARG out_dir=/var/task
ARG numpy_home=https://api.github.com/repos/numpy/numpy

# Update and install compiler dependencies
RUN yum update -y
RUN yum upgrade -y
RUN yum -y install python${python_runtime}-devel gcc-c++ gcc-gfortran libgfortran

# Install NumPy dependencies
RUN yum -y install blas lapack atlas-sse3-devel
RUN python${python_runtime} -m pip install cython

# Download the latest NumPy (using `Requests` and `json` to simplify life).
RUN yum -y install curl unzip
RUN python${python_runtime} -m pip install requests
RUN url=$(python${python_runtime} -c "import json; import requests; r = requests.get(\"${numpy_home}/releases/latest\"); j = r.json(); print(j['zipball_url'])") && curl "$url" -L -o numpy.zip
RUN unzip numpy.zip
RUN rm numpy.zip
RUN mv numpy* numpy

# Copy required scripts into the Docker image
COPY site.cfg /numpy/site.cfg
COPY host.sh /build

# Set environment variables and entry point
ENV PYTHON_RUNTIME ${python_runtime}
ENV OUTDIR ${out_dir}
CMD /build ${PYTHON_RUNTIME} ${OUTDIR}
