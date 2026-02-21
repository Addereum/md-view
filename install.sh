#!/bin/bash
set -e

# md-view installer
# Usage: curl -fsSL https://raw.githubusercontent.com/addereum/md-view/master/install.sh | bash

REPO="addereum/md-view"
BIN_NAME="md-view"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS and architecture
detect_platform() {
    OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
    ARCH="$(uname -m)"
    
    case "$OS" in
        linux) PLATFORM="linux" ;;
        darwin) PLATFORM="macos" ;;
        *)
            echo -e "${RED}Unsupported OS: $OS${NC}"
            exit 1
            ;;
    esac
    
    case "$ARCH" in
        x86_64) ARCH="amd64" ;;
        aarch64|arm64) ARCH="arm64" ;;
        *)
            echo -e "${RED}Unsupported architecture: $ARCH${NC}"
            exit 1
            ;;
    esac
    
    echo "$PLATFORM-$ARCH"
}

# Get latest version from GitHub
get_latest_version() {
    curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Main installation
main() {
    echo -e "${BLUE}Installing md-view...${NC}"
    
    PLATFORM=$(detect_platform)
    VERSION=${VERSION:-$(get_latest_version)}
    
    if [ -z "$VERSION" ]; then
        echo -e "${RED}Failed to get latest version${NC}"
        exit 1
    fi
    
    # Construct download URL
    if [ "$PLATFORM" = "linux-amd64" ]; then
        URL="https://github.com/$REPO/releases/download/$VERSION/md-view-linux-amd64.tar.gz"
    elif [ "$PLATFORM" = "macos-amd64" ]; then
        URL="https://github.com/$REPO/releases/download/$VERSION/md-view-macos-amd64.zip"
    elif [ "$PLATFORM" = "macos-arm64" ]; then
        URL="https://github.com/$REPO/releases/download/$VERSION/md-view-macos-arm64.zip"
    else
        echo -e "${RED}No pre-built binary for $PLATFORM${NC}"
        echo "You can build from source with: cargo install --git https://github.com/$REPO"
        exit 1
    fi
    
    # Create temp directory
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    
    echo -e "${BLUE}Downloading $URL...${NC}"
    
    # Download and extract
    if [[ "$URL" == *.tar.gz ]]; then
        curl -fsSL "$URL" | tar xz
    else
        curl -fsSL -o archive.zip "$URL"
        unzip -q archive.zip
    fi
    
    # Find binary
    if [ -f "$BIN_NAME" ]; then
        BIN_PATH="$TMP_DIR/$BIN_NAME"
    elif [ -f "$BIN_NAME.exe" ]; then
        BIN_PATH="$TMP_DIR/$BIN_NAME.exe"
    else
        BIN_PATH=$(find "$TMP_DIR" -name "$BIN_NAME*" -type f -executable | head -n1)
    fi
    
    if [ -z "$BIN_PATH" ]; then
        echo -e "${RED}Binary not found in archive${NC}"
        exit 1
    fi
    
    # Make executable
    chmod +x "$BIN_PATH"
    
    # Install
    if [ -w "$INSTALL_DIR" ]; then
        mv "$BIN_PATH" "$INSTALL_DIR/$BIN_NAME"
    else
        echo -e "${BLUE}Need sudo to install to $INSTALL_DIR${NC}"
        sudo mv "$BIN_PATH" "$INSTALL_DIR/$BIN_NAME"
    fi
    
    # Cleanup
    cd /
    rm -rf "$TMP_DIR"
    
    echo -e "${GREEN}✓ md-view installed successfully to $INSTALL_DIR/$BIN_NAME${NC}"
    echo -e "${GREEN}Run with: $BIN_NAME${NC}"
}

main "$@"