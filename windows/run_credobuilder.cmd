@echo off
setlocal
set IMAGE=repbioinfo/credobuilder-dind

REM Build dell’immagine
docker build -t %IMAGE% .

REM Run: clona il repo in /workspace/DockerBuilder e resta nella shell
docker run --privileged --rm -it ^
  -v "%cd%":/workspace ^
  -w /workspace ^
  %IMAGE% ^
  bash -lc "git clone --depth 1 https://github.com/Reproducible-Bioinformatics/DockerBuilder.git DockerBuilder || true; ls -la DockerBuilder; echo; echo '[ OK ] Repo pronto in /workspace/DockerBuilder'; exec bash"

endlocal
