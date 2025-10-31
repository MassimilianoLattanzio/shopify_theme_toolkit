#!/bin/sh
set -eu

# Logging helpers
info() {
  echo "$@" >&2
}

error() {
  echo "$(red "$@") ❌" >&2
  exit 1
}

blue() {
  echo "\033[34m$@\033[0m"
}

green() {
  echo "\033[32m$@\033[0m"
}

red() {
  echo "\033[31m$@\033[0m"
}

# Required tools: curl or wget, Node.js, npx, mise or asdf

# Ensure Node.js and npx are installed
if ! command -v node >/dev/null 2>&1 || ! command -v npx >/dev/null 2>&1; then
  error "Error: Node.js and npx are required but not installed."
fi

# Get download tool (curl or wget)
download_tool=""
if command -v curl >/dev/null 2>&1; then
  download_tool="curl"
elif command -v wget >/dev/null 2>&1; then
  download_tool="wget"
else
  error "Error: Neither 'curl' nor 'wget' is installed. Please install one of them to download files."
fi

# Get tool versions manager (mise or asdf)
package_manager=""
if command -v mise >/dev/null 2>&1; then
  package_manager="mise"
elif command -v asdf >/dev/null 2>&1; then
  package_manager="asdf"
else
  error "Error: Neither 'mise' nor 'asdf' is installed. Please install one of them to manage tool versions."
fi

# Get ruby version from parameter or default to package manager latest command
ruby_version="${RUBY_VERSION:-$(command $package_manager latest ruby)}"
if [ -z "$ruby_version" ]; then
  error "Error: Unable to determine Ruby version."
else
  info "Using Ruby version: $(blue "$ruby_version") 💎"
fi

# Get pnpm version from parameter or default to package manager latest command
pnpm_version="${PNPM_VERSION:-$(command $package_manager latest pnpm)}"
if [ -z "$pnpm_version" ]; then
  error "Error: Unable to determine pnpm version."
else
  info "Using pnpm version: $(blue "$pnpm_version") 🧱"
fi

# Ask for the Shopify theme name
info "Enter the name of a new or existing Shopify theme 💬:"
read THEME_NAME </dev/tty

# Check if the theme name is provided
if [ -z "$THEME_NAME" ]; then
  error "Error: Theme name cannot be empty."
fi

# Check if the theme directory already exists
if [ -d "$THEME_NAME" ]; then
  info "Theme folder $(blue "$THEME_NAME") already exists."

  # Ask the user if they want to use the existing folder
  info "Do you want to use the existing folder❔ ($(green "y")/$(red "N"))"
  read USE_EXISTING </dev/tty
  if [ "$USE_EXISTING" != "y" ]; then
    info "$(red "Exiting without making changes.")"
    exit 0
  else
    info "Using existing folder $(blue "$THEME_NAME")."
  fi
else
  # Create the theme using Shopify CLI with the provided name
  info "Creating Shopify theme $(blue "$THEME_NAME")..."
  npx @shopify/cli@latest theme init "$THEME_NAME"
fi

# Navigate into the theme directory
cd "$THEME_NAME" || { error "Failed to enter directory '$THEME_NAME'"; }

# Create .tool-versions file if it doesn't exist
if [ ! -f .tool-versions ]; then
  info "Creating $(blue ".tool-versions") file..."
  touch .tool-versions
fi

# Add ruby version to .tool-versions if not already present
if ! grep -q "^ruby " .tool-versions; then
  info "Adding $(blue "Ruby") version to .tool-versions..."
  echo "ruby $ruby_version" >> .tool-versions
else
  info "$(blue "Ruby") version already specified in .tool-versions."
fi

# Add pnpm version to .tool-versions if not already present
if ! grep -q "^pnpm " .tool-versions; then
  info "Adding $(blue "pnpm") version to .tool-versions..."
  echo "pnpm $pnpm_version" >> .tool-versions
else
  info "$(blue "pnpm") version already specified in .tool-versions."
fi

# Install tools dependencies
info "Installing tool dependencies..."
$package_manager install

# Ensure tools are available in PATH by reshimming/reloading
if [ "$package_manager" = "mise" ]; then
  eval "$(mise env)"
elif [ "$package_manager" = "asdf" ]; then
  eval "$(asdf exec env)"
fi

# Add Shopify CLI to the project dependencies
info "Adding $(blue "Shopify CLI") 🛍️ to project dependencies..."
pnpm add @shopify/cli

# Add foreman to the project dependencies
info "Adding $(blue "foreman") 👨‍💼 to project dependencies..."
if [ ! -f Gemfile ]; then
  bundle init
fi
if ! grep -q "foreman" Gemfile; then
  bundle add foreman
fi

# Add Github Actions workflows to the project
info "Adding $(blue "Github Actions") workflows ☑️ to the project..."
mkdir -p .github/workflows

# Download workflow files from the repository
base_url="https://raw.githubusercontent.com/MassimilianoLattanzio/shopify_theme_toolkit/main/github-workflows"

workflows=(
  "lighthouse-ci.yml"
  "pr-theme.yml"
  "theme-check.yml"
)

for workflow in "${workflows[@]}"; do
  # Skip download if the workflow file already exists
  if [ -f ".github/workflows/$workflow" ]; then
    info "Workflow $(blue "$workflow") already exists. Skipping download."
    continue
  fi

  info "Downloading workflow: $(blue "$workflow")"
  if [ "$download_tool" = "curl" ]; then
    curl -fsSL "$base_url/$workflow" -o ".github/workflows/$workflow"
  elif [ "$download_tool" = "wget" ]; then
    wget -q "$base_url/$workflow" -O ".github/workflows/$workflow"
  fi
  
  if [ $? -eq 0 ]; then
    info "Successfully downloaded $(green "$workflow")"
  else
    error "Error: Failed to download $base_url/$workflow"
  fi
done

# Create bin/dev script using foreman to run the Shopify theme dev server
info "Creating $(blue "bin/dev") script 💻 ..."
mkdir -p bin
if [ -f bin/dev ]; then
  info "$(blue "bin/dev") script already exists. Skipping creation."
else
  cat << 'EOF' > bin/dev
#!/bin/sh

exec foreman start -f Procfile.dev "$@"
EOF
  chmod +x bin/dev
  info "$(blue "bin/dev") script created successfully."
fi

# Create Procfile.dev for foreman
info "Creating $(blue "Procfile.dev") 📑 ..."
if [ -f Procfile.dev ]; then
  info "$(blue "Procfile.dev") already exists. Skipping creation."
else
  touch Procfile.dev
  echo "web: pnpm shopify theme dev" >> Procfile.dev
  info "$(blue "Procfile.dev") created successfully."
fi

info "$(green "Installation complete!") 🎉"
info "To start the development server run 👉: $(green "cd $THEME_NAME && bin/dev")"
