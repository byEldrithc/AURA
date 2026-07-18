# /function aura:apply_shield {id:1,time:20,amount:5,shieldId:1}

## Remove existing if its possible
$attribute @s max_absorption modifier remove aura:$(shieldId)
$kill @e[type=marker,nbt={data:{id:$(id),shieldId:$(shieldId)}}]

## Summon new markers and set
$summon marker 0 2 0 {Tags:["nn.newShield","auraield"],data:{id:$(id),amount:$(amount),shieldId:$(shieldId)}}
$scoreboard players set @e[tag=nn.newShield] aura.maxtimer $(time)
tag @e[tag=nn.newShield] remove nn.newShield

## If not full shield give negative attribute
execute store result score $playerShieldAmount aura.global run data get entity @s AbsorptionAmount 1
execute store result score $playerMaxShieldAmount aura.global run attribute @s max_absorption get 1

scoreboard players operation $calculatedShieldDiff aura.global = $playerShieldAmount aura.global
scoreboard players operation $calculatedShieldDiff aura.global -= $playerMaxShieldAmount aura.global

execute if score $calculatedShieldDiff aura.global matches ..-1 run execute store result storage aura:temp diff int 1 run scoreboard players get $calculatedShieldDiff aura.global
execute if score $calculatedShieldDiff aura.global matches ..-1 run function aura:shield/apply_negative with storage aura:temp

## Give new attribute & apply shield
$attribute @s max_absorption modifier add aura:$(shieldId) $(amount) add_value

effect give @s absorption 1 100 true
effect clear @s absorption

## Clear negative attribute
attribute @s max_absorption modifier remove aura:-99999