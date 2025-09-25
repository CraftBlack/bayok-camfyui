FROM python:3.12

# Install system dependencies
RUN apt-get update && apt-get install -y git aria2 curl

# Clone the repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# Set the working directory
WORKDIR /ComfyUI

# Update pip, install GPU dependencies, and install Comfy dependencies
RUN pip install --upgrade pip && pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 && pip install -r requirements.txt

# Download koyeb_patch_routes.py
RUN aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -o "koyeb_patch_routes.py" "https://files.catbox.moe/t55vaf.py"

# Run koyeb_patch_routes.py
RUN python3 koyeb_patch_routes.py

# Make Folder user and workflows
RUN mkdir -p /ComfyUI/user/default/workflows

# Download Git Repo
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git /ComfyUI/custom_nodes/ComfyUI-Manager

# Input Files
RUN aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -d "/ComfyUI/input" -o "Iuno Lynn ai.png" "https://files.catbox.moe/iz68n8.png" && \
    aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -d "/ComfyUI/input" -o "seed.png" "https://files.catbox.moe/eh66lk.png" && \
    aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -d "/ComfyUI/input" -o "Waguri Kaoruko.png" "https://files.catbox.moe/fio2hl.png"

# Workflows Files
RUN aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -d "/ComfyUI/user/default/workflows" -o "video_wan2_2_14B_i2v.json" "https://files.catbox.moe/1fmg1u.json" && \
    aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -d "/ComfyUI/user/default/workflows" -o "11_wan2.2-seeeeeeee.json" "https://files.catbox.moe/uhdgub.json"

# Download Model Lora
RUN curl -L -H "Authorization: Bearer c892d0db3d52265e969a31dc6bc57e28" "https://civitai.com/api/download/models/2073605?type=Model&format=SafeTensor" -o "/ComfyUI/models/loras/NSFW-22-H-e8.safetensors" && \
    curl -L -H "Authorization: Bearer c892d0db3d52265e969a31dc6bc57e28" "https://civitai.com/api/download/models/2083303?type=Model&format=SafeTensor" -o "/ComfyUI/models/loras/NSFW-22-L-e8.safetensors" && \
    curl -L -H "Authorization: Bearer c892d0db3d52265e969a31dc6bc57e28" "https://civitai.com/api/download/models/2116008?type=Model&format=SafeTensor" -o "/ComfyUI/models/loras/23High noise-Cumshot Aesthetics.safetensors" && \
    curl -L -H "Authorization: Bearer c892d0db3d52265e969a31dc6bc57e28" "https://civitai.com/api/download/models/2116027?type=Model&format=SafeTensor" -o "/ComfyUI/models/loras/56Low noise-Cumshot Aesthetics.safetensors"

# Download Model Diffusion
RUN aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -d "/ComfyUI/models/diffusion_models" -o "wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors?download=true" && \
    aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -d "/ComfyUI/models/diffusion_models" -o "wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"
    
# Download Other Models
RUN aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -d "/ComfyUI/models/vae" -o "wan_2.1_vae.safetensors" "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors?download=true" && \
    aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -d "/ComfyUI/models/text_encoders" -o "umt5_xxl_fp8_e4m3fn_scaled.safetensors" "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors?download=true"

# Download valid_hash.txt
RUN aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -o "valid_hash.txt" "https://files.catbox.moe/cagumu.txt"

# Download verify_model_hashes.py
RUN aria2c --console-log-level=warn --allow-overwrite=true --continue=true --max-connection-per-server=8 --split=8 --min-split-size=1M -o "verify_model_hashes.py" "https://files.catbox.moe/xf9rwd.py"

# Verifikasi Hash
RUN python3 verify_model_hashes.py \
    --models-dir /ComfyUI/models \
    --hash-file /valid_hash.txt

# Set the entry point for the container & RUN!
CMD python3 main.py --listen 0.0.0.0 --port ${PORT:-8188}
