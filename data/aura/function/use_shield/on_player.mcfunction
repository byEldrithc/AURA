
execute if entity @s[type=!player] run return fail
execute if entity @s[tag=immune2shield] run return fail

$execute as @s run function aura:use_shield/__recursive {time:$(time),amount:$(amount),shieldId:$(shieldId)}
