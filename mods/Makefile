DEFAULT_GOAL := help

.PHONY: help build test-packages lint-packages format-packages package-mod publish-mod copy-assets zip-assets push-asset bunwulf-agricultural bunwulf-structural

help: ## Print this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "%-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Type-check all mods against Eco.ReferenceAssemblies via dotnet build.
	dotnet build eco-mods-public.sln --nologo

test-packages: ## Test deterministic per-mod package creation and publishing.
	python3 -m unittest discover -s tests -p 'test_*.py'

lint-packages: ## Lint and format-check the package tooling.
	ruff check scripts/mod_packages.py scripts/validate_workflow.py tests/test_mod_packages.py
	ruff format --check scripts/mod_packages.py scripts/validate_workflow.py tests/test_mod_packages.py

format-packages: ## Format the package tooling.
	ruff format scripts/mod_packages.py scripts/validate_workflow.py tests/test_mod_packages.py

package-mod: ## Package one mod for Forgejo. Env - MOD_NAME, MOD_PACKAGE_NAME, MOD_SOURCE_REVISION.
	python3 scripts/mod_packages.py package \
		--repo-root .. \
		--output ../.build/mod-package \
		--mod "$(MOD_NAME)" \
		--package-name "$(MOD_PACKAGE_NAME)" \
		--revision "$(MOD_SOURCE_REVISION)"

publish-mod: ## Publish one prepared package. Requires the FORGEJO_PACKAGE_* environment.
	python3 scripts/mod_packages.py publish --input ../.build/mod-package

copy-assets: ## Refresh the assets folder from eco-mods-assets. Args - branch=<release-branch>.
	@uv run python scripts/mods.py copy-assets $(if $(branch),--branch=$(branch))

zip-assets: ## Zip Mods/UserCode/<name> into <name>.zip. Args - mod=<Name>.
	@test -n "$(mod)" || { echo "mod=<Name> is required" >&2; exit 2; }
	@rm -f $(mod).zip
	@rm -rf ./Mods/UserCode/$(mod)/bin ./Mods/UserCode/$(mod)/obj
	zip -r $(mod).zip ./Mods/UserCode/$(mod)

push-asset: zip-assets ## Zip a UserCode mod, scp it to kai-server, unzip into the EcoServer tree. Args - mod=<Name>.
	coily gaming eco mod push --src $(mod).zip

bunwulf-agricultural: ## Regenerate BunWulfAgricultural plants from templates.
	@uv run python scripts/mods.py bunwulf-agricultural

bunwulf-structural: ## Regenerate BunWulfStructural recipes from recipes.yml.
	@uv run python scripts/mods.py bunwulf-structural
