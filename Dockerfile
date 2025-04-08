FROM python:3.11-slim

# Homebrew bağımlılıkları
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    file \
    git \
    && rm -rf /var/lib/apt/lists/*

# Homebrew kur
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc \
    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && /home/linuxbrew/.linuxbrew/bin/brew install uv

# Homebrew PATH ayarları
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Çalışma dizini
WORKDIR /app

# Projeyi kopyala
COPY . .

# Giriş komutu
CMD ["uv", "run", "python", "-m", "src.fibery_mcp_server", "--fibery-host", "wecannapp.fibery.io", "--fibery-api-token", "585ccf9b.547018d84b617779dad87add1a81b887e96"]