FROM python:3.12

RUN apt-get install -y git wget curl build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget curl libbz2-dev
RUN apt-get install -y libgl1 libglib2.0-0 netcat-openbsd git-lfs imagemagick util-linux
RUN pip install requests tqdm six huggingface-hub ninja
RUN python --version
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared
RUN chmod +x /usr/local/bin/cloudflared
RUN cloudflared --version
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /ComfyUI
RUN git clone https://github.com/Comfy-Org/ComfyUI-Manager.git /ComfyUI/custom_nodes/ComfyUI-Manager
RUN pip install -r /ComfyUI/requirements.txt
RUN wget -O download_models.py https://files.catbox.moe/97fmey.py
RUN wget -O CIVITAI_API_KEY.txt https://files.catbox.moe/agtax3.txt
RUN python download_models.py

CMD python /ComfyUI/main.py & cloudflared tunnel --url http://localhost:8188 & cloudflared --version
