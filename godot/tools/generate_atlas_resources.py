#!/usr/bin/env python3
"""
Generate Godot 4 AtlasTexture .tres resources from TexturePacker XML atlases,
plus SpriteFrames .tres files for animation sequences.

Run from repo root:  python3 godot/tools/generate_atlas_resources.py
Output goes under godot/assets/atlas/{tex,sprite_frames}/.

This is a one-shot generator — re-run if the source XML changes. The resulting
.tres files are committed and tracked in git like any other resource.
"""

import os
import re
import xml.etree.ElementTree as ET
from collections import defaultdict

GODOT_ROOT = os.path.join(os.path.dirname(__file__), "..")
ATLAS_DIR = os.path.join(GODOT_ROOT, "assets", "atlas")
TEX_DIR = os.path.join(ATLAS_DIR, "tex")
FRAMES_DIR = os.path.join(ATLAS_DIR, "sprite_frames")

os.makedirs(TEX_DIR, exist_ok=True)
os.makedirs(FRAMES_DIR, exist_ok=True)

ATLASES = [
    ("game-assets.xml", "game-assets.png"),
    ("menu-assets.xml", "menu-assets.png"),
]


def safe_name(name: str) -> str:
    return re.sub(r"[^A-Za-z0-9]+", "_", name).strip("_").lower()


def atlas_tex_path(name: str) -> str:
    return f"res://assets/atlas/tex/{safe_name(name)}.tres"


def write_atlas_texture(name: str, png_path: str, x: int, y: int, w: int, h: int) -> None:
    body = f"""[gd_resource type="AtlasTexture" load_steps=2 format=3]

[ext_resource type="Texture2D" path="res://assets/atlas/{png_path}" id="1"]

[resource]
atlas = ExtResource("1")
region = Rect2({x}, {y}, {w}, {h})
"""
    with open(os.path.join(TEX_DIR, f"{safe_name(name)}.tres"), "w") as f:
        f.write(body)


def write_sprite_frames(name: str, anim_name: str, frame_names: list[str], fps: int, loop: bool) -> None:
    load_steps = len(frame_names) + 1
    ext_resources = "\n".join(
        f'[ext_resource type="Texture2D" path="{atlas_tex_path(n)}" id="{i+1}"]'
        for i, n in enumerate(frame_names)
    )
    frames = ",\n".join(
        f'{{ "duration": 1.0, "texture": ExtResource("{i+1}") }}'
        for i in range(len(frame_names))
    )
    body = f"""[gd_resource type="SpriteFrames" load_steps={load_steps} format=3]

{ext_resources}

[resource]
animations = [{{
"frames": [
{frames}
],
"loop": {str(loop).lower()},
"name": &"{anim_name}",
"speed": {fps}.0
}}]
"""
    with open(os.path.join(FRAMES_DIR, f"{safe_name(name)}.tres"), "w") as f:
        f.write(body)


all_subtextures = {}

for xml_name, png_name in ATLASES:
    tree = ET.parse(os.path.join(ATLAS_DIR, xml_name))
    root = tree.getroot()

    sequences: dict[str, list[tuple[int, str]]] = defaultdict(list)

    for sub in root.findall("SubTexture"):
        name = sub.attrib["name"]
        x = int(sub.attrib["x"])
        y = int(sub.attrib["y"])
        w = int(sub.attrib["width"])
        h = int(sub.attrib["height"])
        all_subtextures[name] = (png_name, x, y, w, h)
        write_atlas_texture(name, png_name, x, y, w, h)

        match = re.match(r"^(.+?)(\d+)$", name)
        if match:
            prefix = match.group(1).rstrip("/").rstrip("-").strip()
            index = int(match.group(2))
            sequences[prefix].append((index, name))

    for prefix, items in sequences.items():
        if len(items) < 2:
            continue
        items.sort()
        frame_names = [n for _, n in items]
        anim = safe_name(prefix)
        write_sprite_frames(prefix, anim, frame_names, fps=24, loop=False)


print(f"Generated {len(all_subtextures)} AtlasTexture resources in {TEX_DIR}")
print(f"Generated SpriteFrames in {FRAMES_DIR}")
