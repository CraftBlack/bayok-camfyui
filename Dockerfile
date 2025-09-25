FROM python:3.12

# Clone the repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# Set the working directory
WORKDIR /ComfyUI

# Update pip, install GPU dependencies, and install Comfy dependencies
RUN pip install --upgrade pip && pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 && pip install -r requirements.txt

# Clone ComfyUI-Manager
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git /ComfyUI/custom_nodes/ComfyUI-Manager

# Download Model Lora
RUN curl -L -H "Authorization: Bearer c892d0db3d52265e969a31dc6bc57e28" "https://civitai.com/api/download/models/2073605?type=Model&format=SafeTensor" -o "/ComfyUI/models/loras/NSFW-22-H-e8.safetensors"

# Set the entry point for the container
CMD python3 main.py --listen 0.0.0.0 --port ${PORT:-8188}
