.PHONY: e2e lint lint-shell lint-zsh deploy init

# All lint checks
lint: lint-shell lint-zsh
	@echo "==> All lint checks passed."

# Shell scripts (shellcheck)
lint-shell:
	@echo "==> shellcheck..."
	shellcheck link.sh
	shellcheck test.sh
	shellcheck setup.sh

# Zsh syntax (zsh -n)
lint-zsh:
	@echo "==> zsh syntax..."
	zsh -n config/zsh/zshrc
	zsh -n config/zsh/zprofile

# E2E tests (macOS required, runs on GitHub Actions)
e2e:
	bash test.sh

# Deploy dotfiles (create symlinks)
deploy:
	bash link.sh

# Install git hooks
init:
	ln -sf ../../pre-commit .git/hooks/pre-commit
	@echo "Git hooks installed."
