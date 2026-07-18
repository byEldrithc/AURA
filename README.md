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

## Installation

1. Copy the `AURA` folder into your world's `datapacks/` directory (e.g. `saves/<World Name>/datapacks/AURA`).
2. Run `/reload` in-game, or restart the world.
3. You should see `Shield Library Reloaded!` in chat once it's loaded.

For a general walkthrough on installing data packs, see the [Minecraft Wiki tutorial](https://minecraft.fandom.com/wiki/Tutorials/Installing_a_data_pack).
