void WorldBuilder_main(ScriptComponent @p)
{
p.setTextString("Building island...");
	p.suspend();

	int w = 300;
	int h = 300;

	auto pmap = Perlin_makeNoise(p, w, h, 25, 25);
	Perlin_rectangularMask(pmap, 10);
	Perlin_circularMask(pmap, 50);
	
	// Build Scene

	// Translate tiles

	array<int> tiles;

	// Land, sea, lakes

	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			// From .2, .3 water level...
			auto val = pmap[i][j];
			if (val < 0.2) tiles.insertLast(1);
			else if (val < 0.3) tiles.insertLast(3);
			else if (val < 0.6) tiles.insertLast(5);
			else if (val < 0.8) tiles.insertLast(6);
			else tiles.insertLast(8);
		}
	}

	// Forests

	auto tmap = Perlin_makeNoise(p, w, h, 25, 25);
	int ti = 0;

	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			if (tiles[ti] != 1 and tmap[i][j] > 0.5)
			{
				if (tmap[i][j] < 0.6) tiles[ti] = 8;
				else if (tmap[i][j] < 0.8) tiles[ti] = 9;
				else tiles[ti] = 10;
			}
			++ti;
		}
	}

	// Mountains

	tmap = Perlin_makeNoise(p, w, h, 25, 25);
	ti = 0;

	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			if (tiles[ti] != 1 and tmap[i][j] > 0.6)
			{
				if (tmap[i][j] < 0.8) tiles[ti] =11;
				else if (tmap[i][j] < 0.85) tiles[ti] = 12;
				else tiles[ti] = 13;
			}
			++ti;
		}
	}

	// Start

	int wts = 0;
	while(tiles[wts] == 1 or tiles[wts] == 10 or tiles[wts] == 13)
	{
		wts = p.randomRange(0, tiles.length());
	}

	float wx = wts % w * 32.0f;
	float wy = wts / w * 32.0f;
	gMaster.setReg("destx", wx);
	gMaster.setReg("desty", wy);
	
		
	p.createSceneData("Perlin", w * 32, h * 32, 100, 100);
	p.addSceneLayer("Perlin", "terrain", false);
	p.addSceneLayer("Perlin", "main", false);
	p.addSceneLayer("Perlin", "HUD", true);
	p.addSceneBase("Perlin", "PlayBase");
	p.addSceneTilemap("Perlin", "U5", "terrain", w, h, tiles);
	p.addSceneEntity("Perlin", "Scroll", 1, true, "main", wx - 32.0, wy - 32.0, false);
	
	p.changeScene("Perlin");
}