build:
	docker build --no-cache --tag kevinedwards/devops-toolkit:latest .

guard-%:
	@ if [ "${${*}}" = "" ]; then \
  echo "Variable $* not set"; \
  exit 1; \
  fi

.PHONY: build