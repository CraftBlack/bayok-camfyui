FROM python:3.12

RUN apt-get update && apt-get install -y git wget curl build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev
RUN apt-get install -y libgl1 libglib2.0-0 netcat-openbsd git-lfs imagemagick util-linux
RUN pip install requests tqdm six huggingface-hub ninja
RUN python --version
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared
RUN chmod +x /usr/local/bin/cloudflared
RUN cloudflared --version
RUN mkdir /my_jupyter
RUN pip install notebook
RUN jupyter --version
RUN mkdir /root/.jupyter/
RUN echo "c.ServerApp.allow_origin = '*'" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.ServerApp.disable_check_xsrf = True" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.FileContentsManager.delete_to_trash = False" >> /root/.jupyter/jupyter_notebook_config.py

CMD jupyter notebook --no-browser --port ${PORT:-8888} --ip=0.0.0.0 --allow-root & cloudflared tunnel --url http://localhost:8888 & cloudflared tunnel --url http://localhost:8188 & python download_models.py
