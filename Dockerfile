FROM python:3.11-slim

# Root olarak bazı temel paketleri yükle + bash dahil
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    file \
    git \
    sudo \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Yeni kullanıcı oluştur
RUN useradd -ms /bin/bash devuser

# devuser'a sudo yetkisi ver
RUN echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Kullanıcıya geç
USER devuser
WORKDIR /home/devuser

# Homebrew kurulumu
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Homebrew shellenv ayarını global olarak ENV içine koy
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
ENV HOMEBREW_NO_ANALYTICS=1

# Brew üzerinden uv kurulumu
RUN brew install uv

# Uygulama dizinine geç
WORKDIR /app

# Kodları kopyala
COPY --chown=devuser:devuser . .

# Çalıştırılacak komut
CMD ["uv", "run", "python", "-m", "src.fibery_mcp_server", "--fibery-host", "wecannapp.fibery.io", "--fibery-api-token", "585ccf9b.547018d84b617779dad87add1a81b887e96"]