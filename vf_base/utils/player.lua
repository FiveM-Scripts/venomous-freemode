function generateSpawn()
	for i = 1, #SpawnLocations do
		math.randomseed(GetGameTimer())
		math.random(); math.random(); math.random();
		
		local number =  math.random(1, #SpawnLocations)
		local location = SpawnLocations[number]

		return location
	end
end
