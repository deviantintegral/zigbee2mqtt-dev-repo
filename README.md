# Zigbee2MQTT Development Monorepo

This monorepo contains a development environment for building custom Docker images of Zigbee2MQTT and its related components. It includes the core Zigbee2MQTT project along with its essential dependencies and tools.

Use this repository when you are working on new features or changes to zigbee2mqtt, herdsman, or herdsman-converters, but want to deploy to your own Docker-based environment.

## Getting Started

1. Checkout repositories:
```bash
./init.sh
```

This will checkout the following applications and dependencies:
- `zigbee2mqtt/` - Core Zigbee2MQTT application
- `zigbee2mqtt-frontend/` - Web frontend interface
- `zigbee-herdsman/` - Zigbee network management library
- `zigbee-herdsman-converters/` - Device-specific converters for Zigbee devices

2. Build the Docker image:
```bash
./build.sh
```

3. If you are not developing on the same system you are deploying to, cross-compile the Zigbee2MQTT application for your other hosts:

```bash
# Install QEMU for cross-compilation support.
sudo apt-get update
sudo apt-get install -y qemu-user-static binfmt-support
# Register the QEMU binary formats with Docker.
docker run --privileged --rm tonistiigi/binfmt --install all
```

```bash
# For Intel and AMD systems.
docker build --platform linux/amd64 -t zigbee2mqtt-dev .
# For Apple Silicon Macs and other ARM64 systems.
docker build --platform linux/arm64 -t zigbee2mqtt-dev .
# For Raspberry Pi systems.
docker build --platform linux/arm/v7 -t zigbee2mqtt-dev .
```

You can now export the image to a tarball and load it on your other hosts using the following commands:
```bash
docker image save zigbee2mqtt-dev:latest | ssh your-other-host "docker image load"
```

Now that you've built the image, you can make changes in each checked-out repository, rebuild, and test them in your own environment.

## Development

This monorepo uses PNPM workspaces for package management. The workspace configuration is defined in `pnpm-workspace.yaml`.

## License

This project is licensed under the GPL-3.0 License, like the original Zigbee2MQTT project.