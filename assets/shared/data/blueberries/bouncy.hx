var time = 0; 

function onCreatePost()
{
    add(boyfriend); //put bf on top yeah

    dad.scrollFactor.set(0.8, 0.8);
}

function onUpdate(elapsed:Float)
{
    dad.x = (Math.sin(time)*500) + (boyfriend.x - 250);
    dad.y = Math.abs((Math.sin(time)*125)) + 250;

    time += elapsed;
}