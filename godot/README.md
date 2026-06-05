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

## Asset import (do this once)

1. **Audio.** Copy `assets/audio/*.mp3` from the repo root into
   `godot/assets/audio/`. In the editor, select each `AudioStreamPlayer`
   under the `MusicManager` autoload and assign the corresponding stream.
2. **Sprite atlas.** Either:
   - Re-export `assets/game-assets@2x.png` from TexturePacker using its
     built-in "Godot 4" framework (recommended), or
   - Slice `game-assets@2x.png` into individual PNGs using the
     `assets/game-assets@2x.xml` coordinates.
   Then assign the resulting `AtlasTexture` / `Sprite2D.texture` /
   `SpriteFrames` resources to the placeholder nodes in `play.tscn`,
   `present.tscn`, `santa.tscn`.
3. **Bitmap font.** Drop `assets/GameFont.fnt` + `GameFont.png` into
   `godot/assets/fonts/`; Godot imports BMFont as a `FontFile` automatically.
   Apply it to the `ScoreLabel` and game-over labels.
4. **Particles.** Open `assets/particle.pex` in a text editor; translate the
   parameters (gravity, speed, lifespan, colours) into the
   `CatchParticles` `CPUParticles2D` node in `play.tscn`.
5. **Background.** Add `game_background` from the atlas as the first child
   of `Play` (behind `Elf`), or load `assets/2x/loading-screen.png` as the
   menu background.

## Known TODOs in the scaffold

- `play.gd::_on_game_over` doesn't yet show the game over UI — pick one:
  modal overlay (`add_child(game_over.instantiate())`) or full scene swap
  (`Game.change_state(Game.State.GAME_OVER)`).
- No pause screen yet (was `view/PauseScreen.as`).
- No settings or scores screens yet.
- No Game Center integration (was `GameCenterController.as`).
- `santa.tscn` not extracted yet — the `Santa` node lives inline in
  `play.tscn` for now; promote it to its own scene once you've added the
  bag animation `SpriteFrames`.
- `present_smashed.tscn` not built — add an `AnimatedSprite2D` that plays
  the `smashed00x` frames at the impact point.

## Effort to here vs. remaining

This scaffold is roughly day-one work: structure, autoloads, all
non-trivial controller logic ported. Roughly two weeks of work remain to
hit feature parity with the AIR build (asset import, all UI screens,
polish, store-ready iOS/Android exports).
