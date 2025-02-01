.PHONY: commit

commit:
	git add .
	./scripts/generate-commit-message.sh
