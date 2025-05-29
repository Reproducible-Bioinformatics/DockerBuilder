# Reproducible Docker Environment with CREDO (Two-Stage Build from Official Base)

This repository provides a reproducible and portable Docker environment using [CREDO](https://github.com/CREDOProject/core), starting from the official CREDO base image.

The process is structured in two stages:
- A builder stage (`Dockerfile.stage1`) that installs packages using `credo pip`.
- A final image (`Dockerfile.final`) that applies and saves the environment for runtime usage.

## File Overview

### Dockerfile.stage1
- Starts from the official CREDO base image.
- Copies and executes `credo_install.sh`, which installs packages using `credo pip`.
- The environment is saved in `/credo_env`.

### Dockerfile.final
- Also based on the official CREDO base image.
- Copies the environment from the builder stage.
- Applies and saves the environment using `credo apply && credo save`.

### credo_install.sh
A shell script listing the packages to install via `credo pip`. This is where the environment is defined.

### build_all.sh
Build automation script that:
1. Builds the stage1 image containing the environment definition.
2. Builds the final image that applies and saves the environment.

## Usage Instructions

1. Modify `credo_install.sh` to specify the packages required for your analysis.
2. Build both images by running:
   ```bash
   ./build_all.sh
   ```
3. Run the final image:
   ```bash
   docker run -it credotest
   ```

## Advantages

- Based on the official CREDO base image to ensure consistency and reproducibility.
- Clean separation between environment construction and usage.
- Avoids redundant downloading when building the final image.
- Suitable for portable and offline scientific workflows.
