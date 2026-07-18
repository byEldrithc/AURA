
$execute unless entity @a[scores={aura.id=$(id)}] run return fail

$execute as @a[scores={aura.id=$(id)}] run function aura:shield/end_apply {shieldId:$(shieldId)}
$kill @e[type=marker,nbt={data:{id:$(id),shieldId:$(shieldId)}}]
