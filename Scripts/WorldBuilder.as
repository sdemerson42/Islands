void WorldBuilder_main(ScriptComponent @p)
{
	p.setTextString("Building island...");
	p.suspend();
	//WorldBuilder_bigContinent(p);
	WorldBuilder_buildDungeon(p);
}

void WorldBuilder_bigContinent(ScriptComponent @p)
{
	int w = 300;
	int h = 300;

	auto pmap = Perlin_makeNoise(p, w, h, 25, 25);
	Perlin_rectangularMask(pmap, 10);
	Perlin_circularMask(pmap, 50);
	
	// Build Scene

	// Translate tiles

	array<int> tiles(w * h);
	

	// Land, sea, lakes
	p.log("Water mapping...");
	int ti = 0;
	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			// From .2, .3 water level...
			auto val = pmap[i][j];
			if (val < 0.2) tiles[ti] = 1;
			else if (val < 0.3) tiles[ti] = 3;
			else if (val < 0.6) tiles[ti] = 5;
			else if (val < 0.8) tiles[ti] = 6;
			else tiles[ti] = 8;
			
			++ti;
		}
	}

	// Forests
	p.log("Forest mapping...");
	auto tmap = Perlin_makeNoise(p, w, h, 25, 25);
	ti = 0;

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
	p.log("Mountain mapping...");
	tmap = Perlin_makeNoise(p, w, h, 25, 25);
	ti = 0;

	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			if (tiles[ti] != 1 and tmap[i][j] > 0.6)
			{
				if (tmap[i][j] < 0.8) tiles[ti] = 11;
				else if (tmap[i][j] < 0.85) tiles[ti] = 12;
				else tiles[ti] = 13;
			}
			++ti;
		}
	}
	
	// Convert tmap for further processing
	
	ti = 0;
	array<array<int>> editMap(w, array<int>(h));
	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			editMap[i][j] = tiles[ti];
			++ti;
		}
	}
	
	array<int> btiles = {1, 10, 13};
	
	WorldBuilder_removeBlockedRegions(p, editMap, btiles, 1);
	
	// Convert back...
	
	ti = 0;
	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			tiles[ti] = editMap[i][j];
			++ti;
		}
	}
	
	p.log("Tilemap converted...");

	
	// Start

	int wts = 0;
	while(tiles[wts] == 1 or tiles[wts] == 10 or tiles[wts] == 13)
	{
		++wts;
	}
	
	
	float wx = wts % w * 32.0f;
	float wy = wts / w * 32.0f;
	gMaster.setReg("destx", wx);
	gMaster.setReg("desty", wy);
	
		
	p.createSceneData("Perlin", w * 32, h * 32, 100, 100);
	p.addSceneLayer("Perlin", "terrain", false);
	p.addSceneLayer("Perlin", "main", false);
	p.addSceneLayer("Perlin", "HUD", true);
	p.addSceneEntity("Perlin", "MapLogic", 1, true, "HUD", 0.0, 0.0, false);
	p.addSceneEntity("Perlin", "MapWizard", 1, true, "main", wx, wy, false);
	//p.addSceneBase("Perlin", "PlayBase");
	p.addSceneTilemap("Perlin", "U5", "terrain", w, h, tiles);
	//p.addSceneEntity("Perlin", "Scroll", 1, true, "main", wx - 32.0, wy - 32.0, false);
	
	p.changeScene("Perlin");
}

void WorldBuilder_island(ScriptComponent @p)
{
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
				if (tmap[i][j] < 0.8) tiles[ti] = 11;
				else if (tmap[i][j] < 0.85) tiles[ti] = 12;
				else tiles[ti] = 13;
			}
			++ti;
		}
	}
	
	// Convert tmap for further processing
	
	ti = 0;
	array<array<int>> editMap(w, array<int>(h));
	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			editMap[i][j] = tiles[ti];
			++ti;
		}
	}
	
	array<int> btiles = {1, 10, 13};
	
	WorldBuilder_removeBlockedRegions(p, editMap, btiles, 1);
	
	// Convert back...
	
	ti = 0;
	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			tiles[ti] = editMap[i][j];
			++ti;
		}
	}
	
	p.log("Tilemap converted...");
	
	
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
	p.addSceneEntity("Perlin", "MapLogic", 1, true, "HUD", 0.0, 0.0, false);
	p.addSceneEntity("Perlin", "MapWizard", 1, true, "main", wx, wy, false);
	//p.addSceneBase("Perlin", "PlayBase");
	p.addSceneTilemap("Perlin", "U5", "terrain", w, h, tiles);
	//p.addSceneEntity("Perlin", "Scroll", 1, true, "main", wx - 32.0, wy - 32.0, false);
	
	p.changeScene("Perlin");

}

class Filler
{
	Filler() {}
	Filler(int xx, int yy)
	{
		x = xx;
		y = yy;
	}
	int x;
	int y;
}


array<array<Filler>> WorldBuilder_getRegions(ScriptComponent @p, array<array<int>> @map, array<int> @btiles)
{
	auto w = map.length();
	auto h = map[0].length();
	array<array<int>> smap = map;
	
	// Create simple map to easily abstract blocked vs clear tiles
	
	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			smap[i][j] = 0;
			for (int k = 0; k < btiles.length(); ++k)
			{
				if (map[i][j] == btiles[k])
				{
					smap[i][j] = 1;
					break;
				}
			}
		}
	}
	
	array<array<Filler>> region;
	
	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
				// Scan for region, then fill and store data.
				if (smap[i][j] == 0)
				{
					array<Filler> filler;
					filler.insertLast(Filler(i, j));
					
					region.insertLast(array<Filler>());
					array<Filler> @cregion = @region[region.length() - 1];
					
					// Fill and count region
					
					while(filler.length() > 0)
					{
						int x = filler[0].x;
						int y = filler[0].y;
						
						bool ok = true;
						
						//Top
						if (y - 1 >= 0)
						{
							int cx = x;
							int cy = y - 1;
							if (smap[cx][cy] == 0)
							{
								for (int k = 0; k < filler.length(); ++k)
								{
									if (filler[k].x == cx and filler[k].y == cy)
									{
										ok = false;
										break;
									}
								}
								if (ok)
								{
									filler.insertLast(Filler(cx, cy));
								}
							}
						}
						
						//Left
						ok = true;
						if (x - 1 >= 0)
						{
							int cx = x - 1;
							int cy = y;
							if (smap[cx][cy] == 0)
							{
								for (int k = 0; k < filler.length(); ++k)
								{
									if (filler[k].x == cx and filler[k].y == cy)
									{
										ok = false;
										break;
									}
								}
								if (ok)
								{
									filler.insertLast(Filler(cx, cy));
								}
							}
						}
						
						//Bottom
						ok = true;
						if (y + 1 < h)
						{
							int cx = x;
							int cy = y + 1;
							if (smap[cx][cy] == 0)
							{
								for (int k = 0; k < filler.length(); ++k)
								{
									if (filler[k].x == cx and filler[k].y == cy)
									{
										ok = false;
										break;
									}
								}
								if (ok)
								{
									filler.insertLast(Filler(cx, cy));
								}
							}
						}
						
						//Right
						ok = true;
						if (x + 1 < w)
						{
							int cx = x + 1;
							int cy = y;
							if (smap[cx][cy] == 0)
							{
								for (int k = 0; k < filler.length(); ++k)
								{
									if (filler[k].x == cx and filler[k].y == cy)
									{
										ok = false;
										break;
									}
								}
								if (ok)
								{
									filler.insertLast(Filler(cx, cy));
								}
							}
						}
						
						// Fill map, remove current filler, and update region.
						
						smap[x][y] = 1;
						cregion.insertLast(Filler(x, y));
						filler.removeAt(0);
					}
					p.log("Region mapped. Size: " + region[region.length() - 1].length());
				}
		}
	}
	return region;
}

void WorldBuilder_removeBlockedRegions(ScriptComponent @p, array<array<int>> @map, array<int> @btiles, int fillTile)
{
	p.log("Removing blocked regions...");
	
	auto region = WorldBuilder_getRegions(p, map, btiles);
	
	int max = 0;
	int mainIndex = 0;
	
	for (int i = 0; i < region.length(); ++i)
	{
		if (region[i].length() > max)
		{		
			max = region[i].length();
			mainIndex = i;
		}
	}
	
	for (int i = 0; i < region.length(); ++i)
	{
		if (i != mainIndex)
		{
			for (int k = 0; k < region[i].length(); ++k)
			{
				map[region[i][k].x][region[i][k].y] = fillTile;
			}
			p.log("Region with size " + region[i].length() + " filled.");
		}
	}
	
}

class Room
{
	int id;
	array<int> tpos;
}

class Dungeon
{
	string name;
	array<int> tiles;
	array<Room> rooms;
	int startRoom;
	Filler startPosition;
}

array<Dungeon> gDungeon;

void WorldBuilder_buildDungeon(ScriptComponent @p)
{
	// TEST
	//79 68
	array<array<int>> tmap(100, array<int>(100, 79));
	for (int i = 0; i < 20; ++i)
	{
		for (int j = 0; j < 20; ++j)
		{
			tmap[i][j] = 68;
			if (i == 0 or j == 0 or i == 19 or j == 19) tmap[i][j] = 79;
		}
	}
	
	for (int i = 0; i < 50; ++i)
	{
		for (int j = 19; j < 70; ++j)
		{
			tmap[i][j] = 68;
			if (i == 0 or j == 19 or i == 49 or j == 69) tmap[i][j] = 79;
		}
	}
	
	tmap[10][19] = 68;
	tmap[11][19] = 68;
	
	array<int> tiles(100 * 100);
	int ti = 0;
	for (int j = 0; j < tmap[0].length(); ++j)
	{
		for(int i = 0; i < tmap.length(); ++i)
		{
			tiles[ti] = tmap[i][j];
			++ti;
		}
	}
	
	gMaster.setReg("destx", 32);
	gMaster.setReg("desty", 32);
	p.createSceneData("D1", 3200, 3200, 100, 100);
	p.addSceneLayer("D1", "terrain", false);
	p.addSceneLayer("D1", "main", false);
	p.addSceneLayer("D1", "HUD", true);
	p.addSceneEntity("D1", "MapLogic", 1, true, "HUD", 0.0, 0.0, false);
	p.addSceneBase("D1", "PlayBase");
	p.addSceneTilemap("D1", "U5", "terrain", 100, 100, tiles);
	//p.addSceneEntity("D1", "Scroll", 1, true, "main", wx - 32.0, wy - 32.0, false);
	
	p.changeScene("D1");
	
	
}


