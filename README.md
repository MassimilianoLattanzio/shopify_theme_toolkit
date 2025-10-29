# ShopifyThemeToolkit

Shopify Theme Toolkit is a set of tools and best practices designed to streamline the development and management of Shopify themes. It helps developers build, test, and deploy their themes efficiently.
It can be installed in any existing Shopify theme or used to scaffold a new one.

## Requirements

To use Shopify Theme Toolkit, you need to have the following installed on your system:

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
