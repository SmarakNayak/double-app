# Minimal Expo App

A minimal Expo app with EAS build support, PostgreSQL db, and Foundry for Solidity development.

## Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled

## Quick Start

1. Enter the development environment:
```bash
nix develop
```

2. Install dependencies:
```bash
npm install
# or
bun install
```

3. Start Expo:
```bash
npx expo start
```

## EAS Build

For cloud builds with EAS:
```bash
eas build
```

