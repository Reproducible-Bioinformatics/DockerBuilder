# 🧪 Reproducible Docker Environment with CREDO (Two-Stage Build)

This setup builds a reproducible and portable Docker image using [CREDO](https://github.com/CREDOProject/core), a tool for defining scientific environments in a declarative and shareable way. The process is split into **two stages** to separate the environment *construction* from the final *distribution*.

---

## 📂 File Overview

### `Dockerfile.stage1`
This is the **builder stage**. It:
- Installs CREDO from the official release.
- Copies and executes `credo_install.sh`, which installs the desired packages using `credo pip`.
- Saves the resulting environment under `/credo_env`.

### `Dockerfile.final`
This is the **final runtime image**. It:
- Starts from a fresh `ubuntu:24.04` base.
- Installs only the minimal dependencies to run `credo apply` and `credo save`.
- Copies the pre-installed environment from the builder stage.
- Finalizes the environment by applying and saving it.

### `credo_install.sh`
Shell script that runs `credo pip` to download and install packages into `/credo_env`. This is where you define your environment needs (e.g., `pandas`, `numpy`, `tensorflow`, etc.).

### `build_all.sh`
Automation script to build the entire pipeline:
1. Builds the `credo-stage1` image using `Dockerfile.stage1`.
2. Builds the final image `credotest` using `Dockerfile.final`.

---

## 🚀 How to Use

1. **Customize your environment**  
   Modify `credo_install.sh` to list all required packages using `credo pip`.

2. **Build both images**
   ```bash
   ./build_all.sh
   ```

3. **Run your final image**
   ```bash
   docker run -it credotest
   ```

---

## ✅ Advantages of this setup

- 📦 **Clean separation** of download/build vs runtime
- 🚫 **No redundant downloading** in the final image
- 🔁 **Reproducible and portable**, suitable for scientific analyses
- 🌐 **Offline-capable** once the final image is built

---

## 🧊 Optional Improvements

- Use a `credo_requirements.txt` file for full decoupling of the package list.
- Add volume mounting or `CMD` entries if you want to run analyses right inside the image.

---

Happy science! 🧬🧫🔬
