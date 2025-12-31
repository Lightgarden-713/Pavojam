format:
	find . -type f -name "*.gd" | xargs -I {} gdscript-formatter {}

format-check:
	find . -type f -name "*.gd" | xargs -I {} gdscript-formatter --check {}
