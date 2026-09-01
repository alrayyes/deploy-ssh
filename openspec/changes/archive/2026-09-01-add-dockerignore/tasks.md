## 1. Add .dockerignore

- [x] 1.1 Create `.dockerignore` at the repo root excluding `.git`,
      `node_modules`, `.bun-cache`, `openspec/`, `.claude/`, and editor/OS
      droppings, mirroring `.gitignore`
- [x] 1.2 Verify `docker build --pull -t deploy-ssh:check .` still builds
      successfully and the image still carries `bash`, `git`, `node`,
      `python3`, `ssh`, `scp`
