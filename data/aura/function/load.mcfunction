tellraw @a "Shield Library Reloaded!"


## Scoreboards

scoreboard objectives add aura.global dummy
execute unless score $lastId aura.global matches 0.. run scoreboard players set $lastId aura.global 0
scoreboard objectives add aura.id dummy
scoreboard objectives add aura.timer dummy
scoreboard objectives add aura.maxtimer dummy

## Chunk Load for markers

forceload add 300000 300000 300000 300000