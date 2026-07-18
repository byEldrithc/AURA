# execute positioned 0 1 0 as @p run function aura:use_shield/on_block {time:100,amount:5,shieldId:1,distance:5}


$execute as @a[distance=..$(distance)] run function aura:use_shield/on_player {time:$(time),amount:$(amount),shieldId:$(shieldId)}