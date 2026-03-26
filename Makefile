.PHONY: e2e lint lint-shell lint-zsh deploy dry-run hooks

# All lint checks
lint: lint-shell lint-zsh
	@echo "==> All lint checks passed."

# E2E tests (macOS required, runs on GitHub Actions)
e2e: lint
	bash tests/e2etest.sh

# Shell scripts (shellcheck)
lint-shell:
	@echo "==> shellcheck..."
	shellcheck bin/link.sh
	shellcheck tests/e2etest.sh

# Zsh syntax (zsh -n)
lint-zsh:
	@echo "==> zsh syntax..."
	zsh -n config/zsh/zshrc
	zsh -n config/zsh/zprofile
	zsh -n config/zsh/zshenv
	zsh -n config/zsh/zlogin

# Deploy dotfiles (create symlinks)
deploy:
	bash bin/link.sh

# Preview what deploy would do
dry-run:
	bash bin/link.sh --dry-run

# Install git hooks
hooks:
	ln -sf ../../hooks/pre-commit .git/hooks/pre-commit
	@echo "Git hooks installed."
