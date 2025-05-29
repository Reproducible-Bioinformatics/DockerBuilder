# Reproducible Docker Environment with CREDO (Two-Stage Build from Local Base)

This repository provides a reproducible and portable Docker environment using [CREDO](https://github.com/CREDOProject/core), starting from a local Docker image that replicates the official CREDO base.

The process is structured in three stages:
- A local CREDO base image (`credo/core:local`) built from `Dockerfile.credo`.
- A builder stage (`Dockerfile.stage1`) that installs packages using `credo pip`.
- A final image (`Dockerfile.final`) that applies and saves the environment for runtime usage.

## File Overview

### Dockerfile.credo
- Builds a local base image with CREDO installed (`credo/core:local`).
- Used by both the builder and final stage.

### Dockerfile.stage1
- Based on `credo/core:local`.
- Copies and runs `credo_install.sh` to install packages using `credo pip`.

### Dockerfile.final
- Also based on `credo/core:local`.
- Copies the environment from the builder stage.
- Applies and saves the environment.

### credo_install.sh
A shell script listing the packages to install via `credo pip`. This is where the environment is defined.

### build_all.sh
Automated build script that:
1. Builds the local CREDO base image if not already available.
2. Builds the stage1 image containing the environment.
3. Builds the final image based on the installed environment.

## Usage Instructions

1. Modify `credo_install.sh` to specify the packages required for your analysis.
2. Run the full build process:
   ```bash
   ./build_all.sh
   ```
3. Run the final image:
   ```bash
   docker run -it credotest
   ```

## Advantages

- Full control over the CREDO base image.
- Clean separation between package download and runtime environment.
- Suitable for offline and reproducible workflows.
