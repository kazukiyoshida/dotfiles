.PHONY: test lint deploy dry-run vm-up vm-down clean

# Run lint checks locally
test: lint

# Syntax checks (run on host macOS)
lint:
	@echo "==> Checking zsh syntax..."
	zsh -n zshrc
	zsh -n zprofile
	zsh -n zshenv
	zsh -n zlogin
	@echo "==> Validating peco.json..."
	python3 -c "import json; json.load(open('peco.json'))" && echo "peco.json: OK"
	@echo "==> All lint checks passed."

# Deploy dotfiles (create symlinks)
deploy:
	bash bin/link.sh

# Preview what deploy would do
dry-run:
	bash bin/link.sh --dry-run

# Start macOS test VM (requires KVM)
vm-up:
	docker compose up -d
	@echo ""
	@echo "macOS VM starting. Access via browser: http://localhost:8006"
	@echo "After macOS boots:"
	@echo "  1. Open Terminal"
	@echo "  2. sudo mount_9p shared"
	@echo "  3. cd /Volumes/shared && bash tests/test.sh"

# Stop macOS test VM
vm-down:
	docker compose down

clean:
	docker compose down -v 2>/dev/null || true
	rm -rf /tmp/dotfiles-macos-storage
