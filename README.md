# Reproducible Docker Environment with CREDO (Two-Stage Build)

This repository provides a **fully reproducible and portable Docker environment** built with [CREDO](https://github.com/CREDOProject/core).  
The build process freezes all dependencies — both Python and R — into an immutable environment (`/credo_env`) that can be reapplied anywhere, ensuring determinism and portability.

---

## Build Overview

CREDO builds the environment in **two stages**:

1. **Stage 1 – builder (`Dockerfile.stage1`)**  
   - Based on the official CREDO base image (`ghcr.io/credoproject/core:v0.19.0-amd64`).  
   - Executes `credo_install.sh`, which reads `requirements.txt` and installs each tool using CREDO’s verbs (`pip`, `cran`, `apt`, `github`, etc.).  
   - Saves the complete environment snapshot to `/credo_env`.

2. **Stage 2 – final (`Dockerfile.final`)**  
   - Starts again from a clean CREDO base.  
   - Copies the frozen `/credo_env` directory from the builder image.  
   - Runs `credo apply` to materialize the same environment **without network access**, ensuring reproducibility.

This separation keeps the final image minimal and deterministic.

---

## File Overview

```
.
├── Dockerfile.stage1      # Builds the environment using CREDO
├── Dockerfile.final       # Applies the frozen environment for runtime
├── build_all.sh           # Automates the two-stage build
├── credo_install.sh       # Installs all tools declared in requirements.txt
└── requirements.txt       # Declarative list of software (CREDO syntax)
```

---

## How to Use

1. **Edit `requirements.txt`**  
   Each line declares a package using CREDO verbs.  
   Example:
   ```text
   pip jupyterlab==4.2.5
   pip pandas==2.2.2
   pip numpy==2.0.1
   cran Seurat
   github fastai/fastcore@1.7.12
   ```

2. **Run the full build process**
   ```bash
   ./build_all.sh credotest
   ```

3. **Run the final image**
   ```bash
   docker run -it credotest
   ```

---

## Advantages

- **Deterministic builds** — the same input always yields the same environment.  
- **No network dependency** in the final stage (`credo apply` uses only local artifacts).  
- **Cross-platform reproducibility** — same environment works on Linux, macOS, and Windows (via Docker).  
- **Full transparency** — inspect `/credo_env` to see every installed component.

---

## Windows Usage

Windows users can achieve the same reproducible build by running the preconfigured privileged Docker container that includes CREDO and Docker-in-Docker:

```bat
wun_credobuilder.cmd
```

This will:
1. Build the `repbioinfo/credobuilder-dind` image.
2. Clone the DockerBuilder helper repository if needed.
3. Start an interactive CREDO environment ready to run `build_all.sh`.
