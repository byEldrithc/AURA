

execute unless score @s aura.timer >= @s aura.maxtimer run scoreboard players add @s aura.timer 1

execute if score @s aura.timer >= @s aura.maxtimer run function aura:shield/end with entity @s data