FROM python:3.11-slim

# Root olarak bazı temel paketleri yükle
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    file \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Yeni kullanıcı oluştur
RUN useradd -ms /bin/bash devuser

# devuser'a sudo yetkisi ver
RUN echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Kullanıcıya geç
USER devuser
WORKDIR /home/devuser

# Homebrew kurulumu
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

# shell environment'i aktif et
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install uv

# Uygulama dosyalarını kopyala
WORKDIR /app
COPY --chown=devuser:devuser . .

# Çalıştırılacak komut
CMD ["/bin/bash", "-c", "uv run python -m src.fibery_mcp_server --fibery-host wecannapp.fibery.io --fibery-api-token 585ccf9b.547018d84b617779dad87add1a81b887e96"]