# PavoJam - a small vampire survivors inspired game

Controls:

- Move: Arrow keys or controller stick
- Jump: Space key or A button on xbox controller (X button on PSX controller)

## Playable Builds

We currently have a workflow that builds the game on each commit merged to main.

[![build-workflow](https://github.com/Lightgarden-713/Pavojam/actions/workflows/godot-ci.yml/badge.svg)](https://github.com/Lightgarden-713/Pavojam/actions/workflows/godot-ci.yml)

## Dependencies

- [Godot 4.5.1](https://godotengine.org/)
- (only if you want code formatting) [gdscript-formatter](https://github.com/GDQuest/GDScript-formatter)

## Useful commands

```bash
# Will edit your gdscript files to ensure they're properly formatted
make format

# Will check if all your gdscript files are properly formatted.
make format-check
```

Due to a limitation in `gdscript-format --check` output, you'll only see whether
the files are formatted or not, but that should be enough to know you should run
`make format` or not.
