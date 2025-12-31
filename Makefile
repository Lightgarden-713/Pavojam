format:
	find . -type f -name "*.gd" | xargs -I {} gdscript-formatter {} lint

format-check:
	find . -type f -name "*.gd" | xargs gdscript-formatter --check
