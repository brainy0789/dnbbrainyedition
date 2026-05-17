function onCreatePost()
	initLuaShader("wavy")
	setSpriteShader('bg', 'wavy')
end
	
function onUpdate(elapsed)
	setShaderFloat('bg', 'uWaveAmplitude', 0.1)
	setShaderFloat('bg', 'uFrequency', 5)
	setShaderFloat('bg', 'uSpeed', 2)
end

local time = 0

function onUpdatePost(elapsed)
	setShaderFloat('bg', 'uTime', time/2)
	time = time + elapsed
end