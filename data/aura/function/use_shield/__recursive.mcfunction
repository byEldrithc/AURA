
$data merge storage aura:temp {time:$(time),amount:$(amount),shieldId:$(shieldId)}
execute store result storage aura:temp id int 1 run scoreboard players get @s aura.id
function aura:shield/apply with storage aura:temp