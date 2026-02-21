use eframe::egui;
use egui_commonmark::{CommonMarkCache, CommonMarkViewer};
use rfd::FileDialog;
use std::path::Path;

struct MarkdownApp {
    content: String,
    cache: CommonMarkCache,
    current_file: Option<String>,
}

impl MarkdownApp {
    fn open_file(&mut self) {
        if let Some(path) = FileDialog::new()
            .add_filter("Markdown", &["md", "markdown", "txt"])
            .pick_file()
        {
            self.load_file(&path);
        }
    }
    
    fn load_file(&mut self, path: &Path) {
        match std::fs::read_to_string(path) {
            Ok(content) => {
                self.content = content;
                self.current_file = Some(path.display().to_string());
            }
            Err(err) => {
                eprintln!("Error reading file {}: {}", path.display(), err);
            }
        }
    }
}

impl Default for MarkdownApp {
    fn default() -> Self {
        let initial = "# Welcome to md-view!\n\nThis is **bold text** and *italic text*.\n\n## Features\n- Open files from command line\n- Live preview\n- Powered by Rust 🦀".to_string();
        Self {
            content: initial,
            cache: CommonMarkCache::default(),
            current_file: None,
        }
    }
}

impl eframe::App for MarkdownApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        // Top panel
        egui::TopBottomPanel::top("top_panel").show(ctx, |ui| {
            ui.horizontal(|ui| {
                if ui.button("📂 Open").clicked() {
                    self.open_file();
                }
                if let Some(file) = &self.current_file {
                    let path = Path::new(file);
                    let filename = path.file_name().unwrap_or_default().to_string_lossy();
                    ui.label(format!("📄 {}", filename));
                } else {
                    ui.label("No file open");
                }
            });
        });

        // Main content area
        egui::CentralPanel::default().show(ctx, |ui| {
            // Split into two columns
            ui.columns(2, |cols| {
                // === LEFT COLUMN (Editor) ===
                cols[0].push_id("editor_col", |ui| {
                    ui.vertical(|ui| {
                        ui.heading("📝 Editor");
                        ui.separator();
                        
                        // Scrollable editor
                        egui::ScrollArea::vertical()
                            .id_source("editor_scroll")
                            .show(ui, |ui| {
                                ui.add(
                                    egui::TextEdit::multiline(&mut self.content)
                                        .font(egui::TextStyle::Monospace)
                                        .desired_rows(30)
                                        .desired_width(f32::INFINITY)
                                );
                            });
                    });
                });

                // === RIGHT COLUMN (Preview) ===
                cols[1].push_id("preview_col", |ui| {
                    ui.vertical(|ui| {
                        ui.heading("🔍 Preview");
                        ui.separator();
                        
                        // Scrollable preview
                        egui::ScrollArea::vertical()
                            .id_source("preview_scroll")
                            .show(ui, |ui| {
                                CommonMarkViewer::new("viewer").show(
                                    ui,
                                    &mut self.cache,
                                    &self.content
                                );
                            });
                    });
                });
            });
        });
        
        ctx.request_repaint();
    }
}

fn main() -> eframe::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    let mut app = MarkdownApp::default();
    
    if args.len() > 1 {
        let path = Path::new(&args[1]);
        if path.exists() {
            app.load_file(path);
        } else {
            eprintln!("File not found: {}", path.display());
        }
    }
    
    let options = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default()
            .with_inner_size([1200.0, 800.0])
            .with_resizable(true),
        ..Default::default()
    };
    
    eframe::run_native(
        "Markdown Browser",
        options,
        Box::new(|_cc| Box::new(app)),
    )
}