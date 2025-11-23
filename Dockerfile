FROM python:3.12

# Install system dependencies
RUN apt-get update && apt-get install -y git aria2 curl

# Clone the repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

RUN pwd
