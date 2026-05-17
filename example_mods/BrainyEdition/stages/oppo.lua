local madSong = 'Loops'

function onCreate()
	makeLuaSprite('oppobg', 'oppobg', -700, -200);
	setLuaSpriteScrollFactor('oppobg', 0.1, 0.1); 
	scaleObject('oppobg', 2, 2)
	screenCenter('oppobg')
	addLuaSprite('oppobg', false);

	if songName == madSong then
		makeLuaSprite('shader')
		makeGraphic('shader', screenWidth, screenHeight)
		setScrollFactor('shader')
	end

	makeLuaSprite('cube', 'cube', 400, 550)
	scaleLuaSprite('cube', 2, 2)
	addLuaSprite('cube')
end


local shadname = "wavy"

function onCreatePost()
	initLuaShader("wavy")
	setSpriteShader('oppobg', shadname)
end
	
function onUpdate(elapsed)
	setShaderFloat('oppobg', 'uWaveAmplitude', 0.1)
	setShaderFloat('oppobg', 'uFrequency', 5)
	setShaderFloat('oppobg', 'uSpeed', 2)

end

local time = 0

function onUpdatePost(elapsed)
	setShaderFloat('oppobg', 'uTime', time/2)
	time = time + elapsed
end