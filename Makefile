.PHONY: test test-ubuntu lint clean

test: lint test-ubuntu

lint:
	@echo "==> Checking zsh syntax..."
	zsh -n zshrc || true
	zsh -n zprofile || true
	zsh -n zshenv || true
	zsh -n zlogin || true
	@echo "==> Checking vim config syntax..."
	nvim --headless -c 'if 1 | qall' 2>&1 || true
	@echo "==> Checking tmux config syntax..."
	tmux -f tmux.conf start-server \; kill-server 2>&1 || true
	@echo "==> Validating peco.json..."
	python3 -c "import json; json.load(open('peco.json'))" && echo "peco.json: OK" || echo "peco.json: INVALID"

test-ubuntu:
	@echo "==> Building Ubuntu test image..."
	docker build -f Dockerfile.ubuntu -t dotfiles-test-ubuntu .
	@echo "==> Running Ubuntu tests..."
	docker run --rm dotfiles-test-ubuntu

clean:
	docker rmi dotfiles-test-ubuntu 2>/dev/null || true
