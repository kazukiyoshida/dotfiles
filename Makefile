.PHONY: test lint lint-shell lint-zsh lint-json deploy dry-run vm-up vm-down clean hooks

# Run all checks
test: lint
	bash tests/test.sh

# All lint checks
lint: lint-shell lint-zsh lint-json
	@echo "==> All lint checks passed."

# Shell scripts (shellcheck)
lint-shell:
	@echo "==> shellcheck..."
	shellcheck bin/link.sh
	shellcheck tests/test.sh

# Zsh syntax (zsh -n)
lint-zsh:
	@echo "==> zsh syntax..."
	zsh -n config/zsh/zshrc
	zsh -n config/zsh/zprofile
	zsh -n config/zsh/zshenv
	zsh -n config/zsh/zlogin

# JSON validation
lint-json:
	@echo "==> JSON validation..."
	python3 -c "import json; json.load(open('config/peco/config.json'))" && echo "config.json: OK"

# Deploy dotfiles (create symlinks)
deploy:
	bash bin/link.sh

# Preview what deploy would do
dry-run:
	bash bin/link.sh --dry-run

# Install git hooks
hooks:
	ln -sf ../../hooks/pre-commit .git/hooks/pre-commit
	ln -sf ../../hooks/pre-push .git/hooks/pre-push
	@echo "Git hooks installed."

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
