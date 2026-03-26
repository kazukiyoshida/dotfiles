.PHONY: e2e lint lint-shell lint-zsh deploy dry-run hooks

# All lint checks
lint: lint-shell lint-zsh
	@echo "==> All lint checks passed."

# E2E tests (macOS required, runs on GitHub Actions)
e2e: lint
	bash test.sh

# Shell scripts (shellcheck)
lint-shell:
	@echo "==> shellcheck..."
	shellcheck link.sh
	shellcheck test.sh

# Zsh syntax (zsh -n)
lint-zsh:
	@echo "==> zsh syntax..."
	zsh -n config/zsh/zshrc
	zsh -n config/zsh/zprofile

# Deploy dotfiles (create symlinks)
deploy:
	bash link.sh

# Preview what deploy would do
dry-run:
	bash link.sh --dry-run

# Install git hooks
hooks:
	ln -sf ../../pre-commit .git/hooks/pre-commit
	@echo "Git hooks installed."
