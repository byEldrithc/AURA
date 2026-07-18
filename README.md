## :shield: A.U.R.A. — Absorption-based Universal Reinforcement Architecture

**Version: v1.0**

**AURA** is a datapack library for managing custom absorption shields with independent IDs, durations, and stacking behavior.

:loudspeaker: *This will be shared soon — feedback is important, so let me know what you think or if anything's unclear!*

### How it works

Each shield accepts the following parameters:

- **`time`** — duration in ticks
- **`amount`** — shield strength (`1 heart = 2`)
- **`shieldId`** — unique identifier for this shield. If a new shield is applied with the same `shieldId`, it **replaces** the existing one — regardless of which one is stronger or how much time is left.
- **`distance`** — range in blocks. Only used by `on_block` and `around_entity`.

> :warning: If a player has the **`immune2shield`** tag, **no shield will affect them**, regardless of the function used.

### Functions

```
function aura:use_shield/on_player {time:<time>,amount:<amount>,shieldId:<shieldId>}
```
> Must be run **on an entity**, otherwise it has no effect.

```
function aura:use_shield/on_block {time:<time>,amount:<amount>,shieldId:<shieldId>,distance:<distance>}
```
> Must be run with `execute at` or `execute positioned`.

```
function aura:use_shield/around_entity {time:<time>,amount:<amount>,shieldId:<shieldId>,distance:<distance>}
```
> Similar to `on_block`, but must be run **on an entity**. Does **not** require `execute at`.

### Example

Applying a shield of `5` (2.5 hearts), then a shield of `3` (1.5 hearts) with a **different** `shieldId` stacks both — giving a total of 4 hearts of absorption.

Taking 1 heart of damage leaves 3 hearts remaining. Once the `5` shield expires, only the `3` shield (unaffected) remains.

<!-- Add a demo video/gif here -->

---

## :file_folder: File-by-file breakdown

Everything lives under `data/aura/function/`.

### Root

**`load.mcfunction`** — `#minecraft:load`
Runs once when the datapack is (re)loaded. Prints `Shield Library Reloaded!`, registers the scoreboard objectives the library relies on (`aura.global`, `aura.id`, `aura.timer`, `aura.maxtimer`), initializes the `$lastId` counter, and forceloads the chunk at `300000 300000 300000` where shield-tracking markers are kept.

**`tick.mcfunction`** — `#minecraft:tick`
Runs every tick. Assigns an `aura.id` to any player who doesn't have one yet (via `assign_id`), and ticks every active shield-timer marker (entities tagged `auraield`) by calling `shield/timer` on each.

**`assign_id.mcfunction`**
Gives the executing player a unique, permanent `aura.id` score by incrementing and copying `$lastId`, then tags them `aura.assigned` so this only runs once per player.

### `shield/`

**`start.mcfunction`**
Entry point for creating a new shield on a player. Merges `time`, `amount`, and `shieldId` into `storage aura:temp`, stores the player's `aura.id` into that same storage, then calls `shield/apply` with it.

**`apply.mcfunction`**
The core logic. Removes any existing `max_absorption` modifier with the same `shieldId` and kills any leftover marker for that `id`/`shieldId` pair. Summons a fresh marker (tagged `auraield`) holding the shield's data and sets its `aura.maxtimer` to `time`. Compares the player's current absorption to their max absorption — if it's already over the cap, calculates the overflow and applies a compensating negative modifier via `apply_negative` so the visible absorption doesn't exceed what it should. Adds the new `max_absorption` modifier for `amount`, briefly gives/clears the `absorption` effect to force the health bar to refresh, then clears any leftover overflow-compensation modifier.

**`apply_negative.mcfunction`**
Adds a temporary `max_absorption` modifier with the fixed id `aura:-99999` sized to the calculated `diff`, used only to counteract overflow from `apply`.

**`timer.mcfunction`**
Runs every tick **on the shield's marker entity**. Increments `aura.timer` until it reaches `aura.maxtimer`, at which point it calls `shield/end` (passing the marker's own `data` as the function's NBT source) to expire the shield.

**`end.mcfunction`**
Given a shield's `id` and `shieldId`, checks whether a player with that `aura.id` still exists — if not, aborts. Otherwise runs `end_apply` as that player and kills the now-finished tracking marker.

**`end_apply.mcfunction`**
Removes the `max_absorption` modifier matching `shieldId` from the executing player, actually taking the shield away.

### `use_shield/`

**`on_player.mcfunction`**
Public-facing entry point for giving a shield to a single entity. Fails immediately if the executor isn't a player, or if they carry the `immune2shield` tag. Otherwise forwards `time`, `amount`, and `shieldId` to `use_shield/__recursive`.

**`on_block.mcfunction`**
Public-facing entry point for an area effect anchored to a position (use with `execute at`/`execute positioned`). Runs `use_shield/on_player` on every player within `distance` of the execution point.

**`around_entity.mcfunction`**
Same as `on_block`, but designed to be run **on an entity** instead of a fixed position — no `execute at` needed, since it uses the entity's own location.

**`__recursive.mcfunction`**
Internal helper called by `on_player`. Re-executes `as @s` and calls `shield/start` with the given `time`, `amount`, and `shieldId`, actually kicking off the shield for that player.

### `data/minecraft/tags/function/`

**`load.json`** / **`tick.json`**
Hook `aura:load` and `aura:tick` into vanilla's `#minecraft:load` and `#minecraft:tick` function tags so they run automatically.

## Requirements

`pack_format: 91` — requires a recent Minecraft 1.21.x release. Check the [pack format table](https://minecraft.wiki/w/Pack_format) if you're unsure your version matches.

## Installation

1. Copy the `AURA` folder into your world's `datapacks/` directory (e.g. `saves/<World Name>/datapacks/AURA`).
2. Run `/reload` in-game, or restart the world.
3. You should see `Shield Library Reloaded!` in chat once it's loaded.
