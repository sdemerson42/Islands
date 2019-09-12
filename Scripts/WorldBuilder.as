void WorldBuilder_main(ScriptComponent @p)
{
	p.setTextString("Building island...");
	p.suspend();
	//WorldBuilder_bigContinent(p);
	
	array<string> files;
	files.insertLast("Data/Castle.txt");
	WorldBuilder_readAreaData(p, files);
	
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

class DoorData
{
	string orient;
	int rm1;
	int rm2;
	Filler pos;
	bool opened;
}

class Room
{
	int id;
	array<int> tpos;
	bool visited;
}

class Dungeon
{
	string name;
	array<int> tile;
	array<Room> room;
	array<DoorData> doorData;
	int startRoom;
	int baktile;
}

class HookData
{
	string orient;
	Filler pos;
	int roomid;
}

class RoomData
{
	string name;
	string chance;
	bool unique;
	Filler size;
	array<int> tile;
	array<HookData> hookData;
}

class AreaData
{
	string name;
	string tileset;
	int baktile;
	int floorTile;
	array<RoomData> roomData;
}

array<Dungeon> gDungeon;
array<AreaData> gAreaData;

void WorldBuilder_readAreaData(ScriptComponent @p, array<string> @fname)
{
	p.log("Reading area data...");
	
	for (int i = 0; i < fname.length(); ++i)
	{
		auto f = fname[i];
		array<string> data = p.readDataFromFile(f);
		
		int fi = 0;
		
		AreaData ad;
		ad.name = data[fi++];
		ad.tileset = data[fi++];
		ad.baktile = parseInt(data[fi++]);
		ad.floorTile = parseInt(data[fi++]);
		
		int roomCount = 0;
		int roomTotal = parseInt(data[fi++]);
		
		while(roomCount < roomTotal)
		{
			RoomData rd;
			rd.name = data[fi++];
			rd.chance = data[fi++];
			if (data[fi++] == "unique") rd.unique = true;
			else rd.unique = false;
			rd.size.x = parseInt(data[fi++]);
			rd.size.y = parseInt(data[fi++]);
			for (int j = 0; j < rd.size.x * rd.size.y; ++j)
			{
				int val = parseInt(data[fi++]);
				rd.tile.insertLast(val);
			}
			int hookTotal = parseInt(data[fi++]);
			for (int j = 0; j < hookTotal; ++j)
			{
				string orient = data[fi++];
				Filler pos;
				pos.x = parseInt(data[fi++]);
				pos.y = parseInt(data[fi++]);
				HookData hd;
				hd.orient = orient;
				hd.pos = pos;
				rd.hookData.insertLast(hd);
			}
			ad.roomData.insertLast(rd);
		
			++roomCount;
		}
		
		p.log("Area data " + ad.name + " loaded."); 
		gAreaData.insertLast(ad);
	}
}

RoomData @WorldBuilder_getRoom(ScriptComponent @p, AreaData @ad, array<string> @ur)
{	
	while (true)
	{
		int chanceRoll = p.randomRange(0, 10);
		string chance;
		if (chanceRoll < 6) chance = "common";
		else if (chanceRoll < 9) chance = "uncommon";
		else chance = "rare";
		
		auto @rd = ad.roomData[p.randomRange(0, ad.roomData.length())];
		if (rd.chance == chance)
		{
			if (rd.unique)
			{
				if (ur.find(rd.name) >= 0) continue;
			}
			return rd;
		}
	}
	return null;
}

void WorldBuilder_buildDungeon(ScriptComponent @p)
{
	
	// TEST
	
	int w = 100;
	int h = 100;
	array<HookData> hook;
	int roomTotal = 20;
	int dunid = 0;
	
	int rmid = 0;
	
	auto @ad = gAreaData[0];
	
	array<int> tile(w * h, ad.baktile);
	
	Dungeon dun;
	dun.name = "D1";
	dun.startRoom = 0;
	dun.baktile = ad.baktile;
	
	array<string> uniqueRoom;
	
	// Starting room
	
	Room rm;
	rm.id = rmid++;
	rm.visited = true;
	auto @rd = WorldBuilder_getRoom(p, ad, uniqueRoom);
	if (rd.unique) uniqueRoom.insertLast(rd.name);
	
	int rl = w / 2;
	int rt = h / 2;
	int rr = rl + rd.size.x;
	int rb = rt + rd.size.y;
	
	
	int index = 0;
	for (int j = rt; j < rb; ++j)
	{
		for (int i = rl; i < rr; ++i)
		{
			int ti = j * w + i;
			if (rd.tile[index] != ad.baktile)
			{
				tile[ti] = rd.tile[index];
				rm.tpos.insertLast(ti);
			}
			++index;
		}
	}
	for (int i = 0; i < rd.hookData.length(); ++i)
	{
		HookData hd;
		hd.pos.x = rd.hookData[i].pos.x + rl;
		hd.pos.y = rd.hookData[i].pos.y + rt;
		hd.orient = rd.hookData[i].orient;
		hd.roomid = rm.id;
		hook.insertLast(hd);
	}
	
	dun.room.insertLast(rm);
	
	// Build
	
	int roomCounter = 1;
	while(roomCounter < roomTotal)
	{
		Room rm;
		rm.visited = false;
		@rd = WorldBuilder_getRoom(p, ad, uniqueRoom);
		int hookIndex = p.randomRange(0, hook.length());
		auto @hda = hook[hookIndex];
		
		// Try to find matching hook
		int tryCount = 0;
		bool chk = false;
		auto @hdb = rd.hookData[0];
		while(tryCount < 20)
		{
			++tryCount;
			@hdb = rd.hookData[p.randomRange(0, rd.hookData.length())];
			
			if ((hda.orient == "n" and hdb.orient == "s") or (hda.orient == "s" and hdb.orient == "n") or
			(hda.orient == "w" and hdb.orient == "e") or (hda.orient == "e" and hdb.orient == "w"))
			{
				chk = true;
				break;
			}
		}
		
		if (!chk) continue;
		
		// Orientations
		
		int cl = 0;
		int cr = 0;
		int ct = 0;
		int cb = 0;
		
		if (hdb.orient == "n")
		{
			rl = hda.pos.x - hdb.pos.x;
			rr = rl + rd.size.x;
			rt = hda.pos.y;
			rb = rt + rd.size.y;
			
			cl = rl;
			cr = rr;
			ct = rt + 1;
			cb = rb;
		}
		else if (hdb.orient == "s")
		{
			rl = hda.pos.x - hdb.pos.x;
			rr = rl + rd.size.x;
			rt = hda.pos.y - rd.size.y + 1;
			rb = rt + rd.size.y;
			
			cl = rl;
			cr = rr;
			ct = rt;
			cb = rb - 1;
		}
		else if (hdb.orient == "w")
		{
			rl = hda.pos.x;
			rr = rl + rd.size.x;
			rt = hda.pos.y - hdb.pos.y;
			rb = rt + rd.size.y;
			
			cl = rl + 1;
			cr = rr;
			ct = rt;
			cb = rb;
		}
		else
		{
			rl = hda.pos.x - rd.size.x + 1;
			rr = rl + rd.size.x;
			rt = hda.pos.y - hdb.pos.y;
			rb = rt + rd.size.y;
			
			cl = rl;
			cr = rr - 1;
			ct = rt;
			cb = rb;
		}
		
		// bounds?
		
		if (rl < 1 or rr > w - 2 or rt < 1 or rb > h - 2) continue;
		
		// Empty space?
		
		chk = true;
		for (int j = ct; j < cb; ++j)
		{
			for (int i = cl; i < cr; ++i)
			{
				int ti = j * w + i;
				if (tile[ti] != ad.baktile)
				{
					chk = false;
					break;
				}
			}
		}
		
		if (!chk) continue;
		
		// Build!
		
		if (rd.unique) uniqueRoom.insertLast(rd.name);
		rm.id = rmid++;
		int index = 0;
		for (int j = rt; j < rb; ++j)
		{
			for (int i = rl; i < rr; ++i)
			{
				int ti = j * w + i;
				if (rd.tile[index] != ad.baktile)
				{
					tile[ti] = rd.tile[index];
					rm.tpos.insertLast(ti);
				}
				++index;
			}
		}
		
		// Clear walls at hook
		
		int hti = hda.pos.y * w + hda.pos.x;
		tile[hti] = ad.floorTile;
		if (hdb.orient == "n" or hdb.orient == "s")
		{
			hti += 1;
		}
		else
		{
			hti += w;
		}
		tile[hti] = ad.floorTile;
		
		// Door data
		
		DoorData dd;
		dd.rm1 = hda.roomid;
		dd.rm2 = rm.id;
		dd.pos = hda.pos;
		dd.orient = hda.orient;
		dd.opened = false;
		dun.doorData.insertLast(dd);
		
		// Add room information to dungeon and update hooks
		
		hook.removeAt(hookIndex);
		for (int i = 0; i < rd.hookData.length(); ++i)
		{
			HookData hd;
			hd.pos.x = rd.hookData[i].pos.x + rl;
			hd.pos.y = rd.hookData[i].pos.y + rt;
			hd.orient = rd.hookData[i].orient;
			hd.roomid = rm.id;
			hook.insertLast(hd);
		}
		
		dun.room.insertLast(rm);
		
		++roomCounter;
	}
	
	dun.tile = tile;
	
	gDungeon.insertLast(dun);
	
	int sx = 0;
	int sy = 0;
	while(true)
	{
		int r = p.randomRange(0, tile.length());
		if (tile[r] == ad.floorTile)
		{
			sx = (r % w) * 32;
			sy = (r / w) * 32;
			break;
		}
	}
	
	array<string> dunData;
	dunData.insertLast("dunid");
	dunData.insertLast("0");
	
	gMaster.setReg("destx", 32 * 51);
	gMaster.setReg("desty", 32 * 51);
	p.createSceneData("D1", 3200, 3200, 100, 100);
	p.addSceneLayer("D1", "terrain", false);
	p.addSceneLayer("D1", "main", false);
	p.addSceneLayer("D1", "HUD", true);
	p.addSceneDataEntity("D1", "DungeonLogic", 1, true, "HUD", 0.0, 0.0, false, dunData);
	p.addSceneBase("D1", "PlayBase");
	p.addSceneTilemap("D1", "U5", "terrain", 100, 100, tile);
	p.addSceneEntity("D1", "Scroll", 1, true, "main", sx, sy, false);
	
	p.setTextString("");
	
	p.changeScene("D1");
	
	
}


