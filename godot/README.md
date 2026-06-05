# Santa's Sack — Godot 4 port (scaffold)

This is a draft Godot 4 project scaffolding the port of the AS3/Starling/AIR
original at the repo root. It compiles and opens, but assets and several
gameplay wiring details still need to be filled in.

## Open in editor

1. Install **Godot 4.3+** (standard build — GDScript, not the .NET build).
2. `Project > Import...` and select `godot/project.godot`.
3. The first import will create a `.godot/` cache (gitignored).

## What's in here

```
godot/
├── project.godot           ← settings: 320×480 portrait, autoloads, stretch
├── scripts/
│   ├── constants.gd        ← STAGE_*, GROUND_Y, MAX_DROPS, init speeds/rates
│   ├── game.gd             ← autoload: scene state switcher
│   ├── game_data.gd        ← autoload: high scores + mute, persists to user://
│   ├── music_manager.gd    ← autoload: music + sfx players
│   ├── elf.gd              ← back-and-forth tween (was ElfController.as)
│   ├── santa.gd            ← drag-to-move + nice_catch (was Santa.as)
│   ├── present.gd          ← falling sprite + catch/hit signals (was Present.as)
│   ├── present_spawner.gd  ← time-based spawn + difficulty ramp (was PresentController.as)
│   ├── drop_counter.gd     ← missed-present meter (was DropController.as)
│   └── play.gd             ← round orchestration (was state/Play.as)
├── scenes/
│   ├── main_menu.tscn      ← placeholder (Start button only)
│   ├── play.tscn           ← wired Elf/Santa/Spawner/Presents/DropCounter
│   ├── present.tscn        ← Sprite2D + Area2D
│   └── game_over.tscn      ← placeholder (Play Again / Main Menu)
└── assets/                 ← empty; populate per "Asset import" below
    ├── atlas/   audio/   fonts/   ui/
```

## Mapping to the original

| AS3 file | Godot equivalent |
|---|---|
| `SantasSack.as` | `project.godot` (window/stretch) + `main_menu.tscn` |
| `core/Game.as` | `scripts/game.gd` (autoload) |
| `state/Main/Play/GameOver.as` | `scenes/main_menu.tscn` / `play.tscn` / `game_over.tscn` |
| `controllers/ElfController.as` | `scripts/elf.gd` |
| `controllers/PresentController.as` | `scripts/present_spawner.gd` |
| `controllers/CollisionController.as` | `Area2D` on `Present` + `CatchArea` on `Santa` |
| `controllers/DropController.as` | `scripts/drop_counter.gd` |
| `controllers/GameCenterController.as` | TODO — needs an iOS plugin |
| `view/Santa.as` | `scripts/santa.gd` |
| `view/Present.as` | `scripts/present.gd` |
| `view/Elf.as`, `view/Bag.as`, `view/PresentSmashed.as` | sprite child nodes |
| `view/ScoreBoard.as` | `Label` in `play.tscn` (replace with BMFont later) |
| `view/GameOverWindow.as`, `Menu.as`, `Settings.as`, `Scores.as`, `PauseScreen.as` | `Control`-based UI scenes (TODO) |
| `models/Assets.as` | `game_data.gd` + Godot's `ResourceLoader` |
| `utils/MusicManager.as` | `scripts/music_manager.gd` |
| `utils/Constants.as` | `scripts/constants.gd` |
| `utils/ObjectPool.as` | not needed at this scale; revisit if profiling demands |
| `release_nape.swc` (Nape physics) | not needed — original code uses point distance, no real physics |

## Assets — already imported

The repo's @2x sprite atlases, audio, bitmap font, and particle file are
copied under `godot/assets/`, and 48 `AtlasTexture` `.tres` resources plus
4 `SpriteFrames` `.tres` files are pre-generated. All scenes reference real
textures — opening the project should render the game art straight away.

Regenerate if `assets/atlas/*.xml` changes:

```bash
python3 godot/tools/generate_atlas_resources.py
```

Notes on what's done vs. still rough:

- **Project base** is 640×960 so the @2x assets render 1:1; Godot's
  `canvas_items / keep` stretch handles all real device sizes.
- **Audio** streams are loaded at runtime by `music_manager.gd`; the
  music stream's `loop` flag is set in code so it loops without editor
  intervention.
- **Bitmap font** is applied to `ScoreLabel` via `theme_override_fonts`.
- **Particles** use a rough hand-translated `CPUParticles2D` config.
  Open `assets/atlas/particle.pex` and refine colours/speeds in the
  inspector when you have the real values in front of you.
- **Positions** (Santa Y offset, pause-button placement, drop-counter Y)
  are first-pass best guesses — tweak in the editor.
- **Menu/game-over buttons** are `Sprite2D`s without input handling yet;
  swap to `TextureButton` and wire `pressed` to `Game.change_state(...)`
  in a follow-up pass.

## Known TODOs in the scaffold

- Menu and game-over buttons are `Sprite2D` placeholders — convert to
  `TextureButton` and wire signals to `Game.change_state(...)`.
- `play.gd::_on_game_over` doesn't yet show the game over UI — pick one:
  modal overlay (`add_child(game_over.instantiate())`) or full scene swap
  (`Game.change_state(Game.State.GAME_OVER)`).
- No pause screen yet (was `view/PauseScreen.as`).
- No settings or scores screens yet.
- No Game Center integration (was `GameCenterController.as`).
- `present_smashed.tscn` not built — wire the
  `presents_smashed_present.tres` `SpriteFrames` to an `AnimatedSprite2D`
  that plays once at each ground-impact point.
- Particle parameters in `play.tscn` are placeholder; refine from the
  values in `assets/atlas/particle.pex`.

## Effort to here vs. remaining

This scaffold is roughly day-one work: structure, autoloads, all
non-trivial controller logic ported. Roughly two weeks of work remain to
hit feature parity with the AIR build (asset import, all UI screens,
polish, store-ready iOS/Android exports).
