# md-view 📝🔍

A sleek, fast Markdown viewer with live preview, written in pure Rust using egui.

## ✨ Features

- 📝 **Live preview** — See your Markdown rendered as you type
- 🔍 **Dual-pane view** — Editor on the left, preview on the right
- 📂 **Open files** — Via GUI or command line
- 🎨 **Proper Markdown rendering** — Headers, bold, italic, lists, and more
- ⚡ **Blazing fast** — Built with Rust and egui
- 🪟 **Cross-platform** — Windows, macOS, Linux
- 🖱️ **Scrollable** — Both panes scroll independently

## 🚀 Installation

### One-liner (Linux & macOS)

    curl -fsSL https://raw.githubusercontent.com/addereum/md-view/master/install.sh | bash

### From GitHub Releases

Download the latest binary for your platform from the [Releases page](https://github.com/addereum/md-view/releases).

Platform

Download

Linux (x86_64)

`md-view-linux-amd64.tar.gz`

macOS (Intel)

`md-view-macos-amd64.zip`

macOS (Apple Silicon)

`md-view-macos-arm64.zip`

Windows

`md-view-windows-amd64.zip`

### From Source

    # Clone the repository
    git clone https://github.com/addereum/md-view.git
    cd md-view

    # Build
    cargo build --release

    # Binary is at target/release/md-view (or md-view.exe on Windows)

### With Cargo

    cargo install --git https://github.com/addereum/md-view.git

## 📖 Usage

### Launch with default content

    md-view

### Open a specific file

    md-view README.md

### Open from file dialog

README.html

Just click the **📂 Open** button in the top panel.

## 🛠️ Building from Source

    # Clone
    git clone https://github.com/addereum/md-view.git
    cd md-view

    # Build in release mode
    cargo build --release

    # Run
    cargo run -- [filename]

## 📦 Dependencies

- [egui](https://github.com/emilk/egui) — Immediate mode GUI library
- [egui_commonmark](https://github.com/lampsitter/egui_commonmark) — Markdown rendering
- [rfd](https://github.com/PolyMeilex/rfd) — Native file dialogs

## 🧪 Example

Create a file `test.md`:

    # My Document

    This is **bold** and *italic*.

    - List item 1
    - List item 2

    ## Subheading

    More content here...

Then:

    md-view test.md

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit PRs.

1.  Fork the repository
2.  Create your feature branch (`git checkout -b feature/amazing`)
3.  Commit your changes (`git commit -m 'Add amazing feature'`)
4.  Push to the branch (`git push origin feature/amazing`)
5.  Open a Pull Request

## 📄 License

MIT / Apache-2.0

## 🙏 Acknowledgments

- [Linus Torvalds](https://github.com/torvalds) for inspiration
- The Rust community for amazing crates
- You, for checking out this project!

---

**Made with 🦀 in Rust**
