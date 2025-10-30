# ShopifyThemeToolkit

Shopify Theme Toolkit is a set of tools and best practices designed to streamline the development and management of Shopify themes. It helps developers build, test, and deploy their themes efficiently.
It can be installed in any existing Shopify theme or used to scaffold a new one.

## Requirements

To use Shopify Theme Toolkit, you need to have the following installed on your system:

- curl or wget (to download the installation script and workflow files)
- Node.js and npx (to create a new Shopify theme if not already existing)
- mise or asdf (for version management)

## Installation

```sh
curl https://raw.githubusercontent.com/MassimilianoLattanzio/shopify_theme_toolkit/refs/heads/main/install.sh | sh
```

### Options

You can pass the following environment variables to customize the installation:

- `RUBY_VERSION`: Specify a Ruby version (default: latest)
- `PNPM_VERSION`: Specify a pnpm version (default: latest)

Example:

```sh
curl https://raw.githubusercontent.com/MassimilianoLattanzio/shopify_theme_toolkit/refs/heads/main/install.sh | RUBY_VERSION=3.1.2 bash -s
```

## Features

- Theme scaffolding: Quickly create a new Shopify theme with a skeleton structure using the default Shopify CLI command.
- Tools file: A pre-configured tools file to manage your development dependencies using mise or asdf.
- Shopify CLI integration: Seamless integration with the Shopify CLI for theme development and deployment.
- Adds multiple GitHub Actions workflows for automated theme checking and testing:
  - Theme Check Workflow: Automatically runs Shopify's Theme Check on every push to ensure code quality and adherence to best practices (https://github.com/marketplace/actions/run-theme-check-on-shopify-theme).
  - Lighthouse CI Workflow: Runs Lighthouse audits on your theme to ensure optimal performance and accessibility (https://github.com/marketplace/actions/run-lighthouse-ci-on-shopify-theme).
  - PR Theme Management Workflow: Manages theme previews for pull requests, allowing for easy testing and review of changes (https://github.com/marketplace/actions/shopify-pr-theme-preview).
- Foreman default setup: A default Procfile for running the Shopify theme dev server using bin/dev command.
