# Mermaid Preview Plugin for Yazi

A Yazi plugin that provides preview functionality for Mermaid diagram files.

## Features

- Preview `.mmd` and `.mermaid` files as rendered diagrams
- Automatic conversion to SVG using mermaid-cli
- Caching for improved performance
- Transparent background for better theme compatibility

## Requirements

- [mermaid-cli](https://github.com/mermaid-js/mermaid-cli) (`mmdc` command)
- Yazi with image preview support

## Installation

1. Install mermaid-cli:
   ```bash
   npm install -g @mermaid-js/mermaid-cli
   ```

2. Copy this plugin to your Yazi plugins directory:
   ```bash
   cp -r mermaid.yazi ~/.config/yazi/plugins/
   ```

3. Add the following to your `~/.config/yazi/yazi.toml`:
   ```toml
   [plugin]
   prepend_previewers = [
     { name = "*.mmd", run = "mermaid" },
     { name = "*.mermaid", run = "mermaid" }
   ]
   ```

## Usage

Navigate to any `.mmd` or `.mermaid` file in Yazi, and the preview pane will automatically show the rendered diagram.

## License

MIT