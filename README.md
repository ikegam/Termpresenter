# TermPresenter

TermPresenter is a presentation tool that works entirely inside a terminal. It converts text and image slides into ASCII art so you can present over SSH, serial consoles or any other terminal connection.

## Requirements
- Ruby
- Pango library for Ruby
- netpbm utilities (for image conversion)
- standard UNIX tools such as `cut`

## Installation
```bash
git clone https://github.com/ikegam/Termpresenter.git
cd Termpresenter
bundle install
chmod +x ./bin/tmptr
./bin/tmptr -h
```

## Usage
Slides are stored as files inside the `presen/` directory. Run `./bin/tmptr` to start the presentation. Use the following keys while running:

- `n` : next page
- `p` : previous page
- `c` : execute command
- `l` : reload slides from directory
- `q` : quit

## Directory layout
- `presen/` – sample presentation files
- `lib/` – application libraries
- `bin/tmptr` – launcher script

