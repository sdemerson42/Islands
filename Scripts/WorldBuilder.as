class Coord
{
	Coord() {}
	Coord(int xx, int yy)
	{
		x = xx;
		y = yy;
	}
	int x;
	int y;
}

class DoorData
{
	string orient;
	int rm1;
	int rm2;
	Coord pos;
	bool opened;
	bool spawned = false;
}

class MobData
{
	string tag;
	Coord position;
}

class Room
{
	int id;
	array<int> tpos;
	bool visited;
	array<MobData> mobData;
	Coord size;
}

class Dungeon
{
	string name;
	Coord size;
	string tileset;
	array<int> tile;
	array<Room> room;
	array<DoorData> doorData;
	int startRoom;
	int baktile;
	Coord startPosition;
	Coord worldPosition;
	array<MobData> spawnedMobs;
}

class HookData
{
	string orient;
	Coord pos;
	int roomid;
}

class RoomData
{
	string name;
	string chance;
	bool unique;
	Coord size;
	array<int> tile;
	array<HookData> hookData;
}

class AreaData
{
	string name;
	string tileset;
	int baktile;
	int floorTile;
	int wallTile;
	array<RoomData> roomData;
}

class NaturalFeatureData
{
	string name;
	Coord centerPosition;
	array<int> tpos;
}

array<Dungeon> gDungeon;
array<AreaData> gAreaData;
array<NaturalFeatureData> gNaturalFeature;

string WorldBuilder_directionsTest(ScriptComponent @p, Coord b, Coord e)
{
	const float PI = 3.14159;
	Coord c;
	c.x = (b.x + e.x) / 2;
	c.y = (b.y + e.y) / 2;
	
	// Find natural feature nearest the center point
	
	int dist = 1000000;
	NaturalFeatureData @midFeature;
	for (int i = 0; i < gNaturalFeature.length(); ++i)
	{
		auto @nfd = gNaturalFeature[i];
		int ld = sqrt((nfd.centerPosition.x - c.x) ** 2 + (nfd.centerPosition.y - c.y) **2);
		if (ld < dist)
		{
			dist = ld;
			@midFeature = nfd;
		}
	}
	
	dist = sqrt((midFeature.centerPosition.x - b.x) ** 2 + (midFeature.centerPosition.y - b.y) ** 2);
	
	p.log("Start: " + b.x + ", " + b.y);
	p.log("End: " + e.x + ", " + e.y);
	p.log("Feature: " + midFeature.centerPosition.x + ", " + midFeature.centerPosition.y);
	
	string dir;
	int dx = midFeature.centerPosition.x - b.x;
	int dy = (midFeature.centerPosition.y - b.y) * -1;
	float deg;
	if (dx == 0)
	{
		if (dy > 0) dir = "north";
		else dir = "south";
	}
	else
	{
		float tang = float(dy) / float(dx);
		float rads = atan(tang);
		deg = rads * 180.0 / PI;
		
		if (dx > 0)
		{
			if (dy < 0) deg = 360 + deg;
		}
		else
		{
			deg = 180 + deg;
		}
	}
	
	if (deg >= 348.75 or deg <= 11.25) dir = "east";
	else if (deg >= 348.75 - 22.5 * 1) dir = "east-southeast";
	else if (deg >= 348.75 - 22.5 * 2) dir = "southeast";
	else if (deg >= 348.75 - 22.5 * 3) dir = "south-southeast";
	else if (deg >= 348.75 - 22.5 * 4) dir = "south";
	else if (deg >= 348.75 - 22.5 * 5) dir = "south-southwest";
	else if (deg >= 348.75 - 22.5 * 6) dir = "southwest";
	else if (deg >= 348.75 - 22.5 * 7) dir = "west-southwest";
	else if (deg >= 348.75 - 22.5 * 8) dir = "west";
	else if (deg >= 348.75 - 22.5 * 9) dir = "west-northwest";
	else if (deg >= 348.75 - 22.5 * 10) dir = "northwest";
	else if (deg >= 348.75 - 22.5 * 11) dir = "north-northwest";
	else if (deg >= 348.75 - 22.5 * 12) dir = "north";
	else if (deg >= 348.75 - 22.5 * 13) dir = "north-northeast";
	else if (deg >= 348.75 - 22.5 * 14) dir = "northeast";
	else dir = "east-northeast";
	
	
	string msg;
	msg += ("Travel " + (dist / 300) + " days\n" + dir + " toward\n" + midFeature.name + ",\n");
	
	dx = e.x - midFeature.centerPosition.x;
	dy = (e.y - midFeature.centerPosition.y) * -1;
	if (dx == 0)
	{
		if (dy > 0) dir = "north";
		else dir = "south";
	}
	else
	{
		float tang = float(dy) / float(dx);
		float rads = atan(tang);
		deg = rads * 180.0 / PI;
		
		if (dx > 0)
		{
			if (dy < 0) deg = 360 + deg;
		}
		else
		{
			deg = 180 + deg;
		}
	}
	
	if (deg >= 348.75 or deg <= 11.25) dir = "east";
	else if (deg >= 348.75 - 22.5 * 1) dir = "east-southeast";
	else if (deg >= 348.75 - 22.5 * 2) dir = "southeast";
	else if (deg >= 348.75 - 22.5 * 3) dir = "south-southeast";
	else if (deg >= 348.75 - 22.5 * 4) dir = "south";
	else if (deg >= 348.75 - 22.5 * 5) dir = "south-southwest";
	else if (deg >= 348.75 - 22.5 * 6) dir = "southwest";
	else if (deg >= 348.75 - 22.5 * 7) dir = "west-southwest";
	else if (deg >= 348.75 - 22.5 * 8) dir = "west";
	else if (deg >= 348.75 - 22.5 * 9) dir = "west-northwest";
	else if (deg >= 348.75 - 22.5 * 10) dir = "northwest";
	else if (deg >= 348.75 - 22.5 * 11) dir = "north-northwest";
	else if (deg >= 348.75 - 22.5 * 12) dir = "north";
	else if (deg >= 348.75 - 22.5 * 13) dir = "north-northeast";
	else if (deg >= 348.75 - 22.5 * 14) dir = "northeast";
	else dir = "east-northeast";
	
	dist = sqrt((e.x - midFeature.centerPosition.x) ** 2 + (e.y - midFeature.centerPosition.y) ** 2);
	msg += ("then another " + (dist / 300) + " days\n" + dir + " until you\nreach the mountains.");
	
	p.log(msg);
	return msg;
}

void WorldBuilder_main(ScriptComponent @p)
{
	p.setTextString("Building World...");
	p.suspend();
	//WorldBuilder_bigContinent(p);
	
	array<string> files;
	files.insertLast("Data/Castle.txt");
	WorldBuilder_readAreaData(p, files);
	WorldBuilder_buildContinent(p, 300, 300);
	
	p.setTextString("");
	p.changeScene("World");
}

void WorldBuilder_buildContinent(ScriptComponent @p, int w, int h)
{
	
	p.setTextString("Building Continent...");
	p.suspend(1);
	
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
	WorldBuilder_identifyNaturalFeatures(p, editMap);
	
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

	// Build Areas - TEMP
	
	int tax = 0;
	int tay = 0;
	int nfi = 0;
	NaturalFeatureData @nf = null;
	while(true)
	{
		int r = p.randomRange(0, gNaturalFeature.length());
		if (gNaturalFeature[r].name == "High Mountains")
		{
			@nf = gNaturalFeature[r];
			nfi = r;
			break;
		}
	}
	while(true)
	{
		int r = p.randomRange(0, nf.tpos.length());
		if (tiles[nf.tpos[r]] == 13 and tiles[nf.tpos[r] + w] == 12)
		{
			tiles[nf.tpos[r]] = 12;
			tax = (nf.tpos[r] % w) * 32;
			tay = (nf.tpos[r] / w) * 32;
			break;
		}
	}
	array<string> areaData;
	areaData.insertLast("0");
	areaData.insertLast("Prison");
	
	WorldBuilder_buildDungeon(p, "Prison", "Castle", 200, 200, 30, 6, tax, tay + 32); 
	
	// Start

	int wts = 0;
	int wx = 0;
	int wy = 0;
	while(tiles[wy * w + wx] != 5)
	{
		wx = p.randomRange(0, w);
		wy = p.randomRange(0, h);
	}
	wx *= 32;
	wy *= 32;
	
	gMaster.setReg("destx", tax);
	gMaster.setReg("desty", tay + 32);
	
		
	p.createSceneData("World", w * 32, h * 32, 100, 100);
	p.addSceneLayer("World", "terrain", false);
	p.addSceneLayer("World", "main", false);
	p.addSceneLayer("World", "HUD", true);
	p.addSceneEntity("World", "MapLogic", 1, true, "HUD", 0.0, 0.0, false);
	p.addSceneDataEntity("World", "InvisibleMapIcon", 1, true, "main", tax, tay, false, areaData);
	p.addSceneEntity("World", "MapWizard", 1, true, "main", wx, wy, false);
	array<string> clueData;
	clueData.insertLast("nodeTotal");
	clueData.insertLast("1");
	clueData.insertLast("0");
	Coord b;
	b.x = wx;
	b.y = wy;
	Coord e;
	e.x = tax;
	e.y = tay;
	clueData.insertLast(WorldBuilder_directionsTest(p, b, e));
	p.addSceneDataEntity("World", "ClueChest", 1, true, "main", wx + 32, wy + 32, false, clueData);
	p.addSceneTilemap("World", "U5", "terrain", w, h, tiles);
}


array<array<Coord>> WorldBuilder_getRegions(ScriptComponent @p, array<array<int>> @map, array<int> @btiles)
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
	
	array<array<Coord>> region;
	
	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
				// Scan for region, then fill and store data.
				if (smap[i][j] == 0)
				{
					array<Coord> filler;
					filler.insertLast(Coord(i, j));
					
					region.insertLast(array<Coord>());
					array<Coord> @cregion = @region[region.length() - 1];
					
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
									filler.insertLast(Coord(cx, cy));
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
									filler.insertLast(Coord(cx, cy));
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
									filler.insertLast(Coord(cx, cy));
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
									filler.insertLast(Coord(cx, cy));
								}
							}
						}
						
						// Fill map, remove current filler, and update region.
						
						smap[x][y] = 1;
						cregion.insertLast(Coord(x, y));
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

void WorldBuilder_identifyNaturalFeatures(ScriptComponent @p, array<array<int>> @map)
{
	array<int> featureTile = {10, 13};
	array<int> bTiles = {1,3, 5, 6, 8, 9, 10, 11, 12, 13};
	
	for (int k = 0; k < featureTile.length(); ++k)
	{
		int ft = featureTile[k];
		int ftIndex = bTiles.find(ft);
		bTiles.removeAt(ftIndex);
		
		auto region = WorldBuilder_getRegions(p, map, bTiles);
		for (int i = 0; i < region.length(); ++i)
		{
			auto @r = region[i];
			NaturalFeatureData nfd;
			int xMin = 20000;
			int yMin = 20000;
			int xMax = -1;
			int yMax = -1;
			for (int j = 0; j < r.length(); ++j)
			{
				auto @c = r[j];
				if (c.x < xMin) xMin = c.x;
				if (c.x > xMax) xMax = c.x;
				if (c.y < yMin) yMin = c.y;
				if (c.y > yMax) yMax = c.y;
				nfd.tpos.insertLast(c.y * map.length() + c.x);
			}
			if (nfd.tpos.length() < 40) continue;
			Coord center;
			center.x = (xMin + xMax) / 2 * 32;
			center.y = (yMin + yMax) / 2 * 32;
			
			if (ft == 10) nfd.name = "A Dark Forest";
			else nfd.name = "High Mountains";
			nfd.centerPosition = center;
			gNaturalFeature.insertLast(nfd);
			p.log("Natural feature: " + nfd.name + ", with center " + nfd.centerPosition.x + ", " + nfd.centerPosition.y);
		}
		
		bTiles.insertLast(ft);
	}
	
}

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
		ad.wallTile = parseInt(data[fi++]);
		
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
				Coord pos;
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

void WorldBuilder_addMobData(ScriptComponent @p, Dungeon @dun)
{
	// TEST - Currently passages are given no size and will not spawn mobs.
	// Add mobs to dungeon rooms
	
	auto block = p.blockedTiles(dun.tileset);
	
	for (int k = 0; k < dun.room.length(); ++k)
	{
		auto @rm = dun.room[k];
		if (rm.size.x == 0 or rm.size.y == 0) continue;
		
		// For now - randomly place 0 - 3 bats. NOTE: Not yet checking for overlapping spawns!
		
		int r = p.randomRange(0, 4);
		for (int m = 0; m < r; ++m)
		{
			int mx = 0;
			int my = 0;
			while(true)
			{
				int ti = rm.tpos[p.randomRange(0, rm.tpos.length())];
				if (block.find(dun.tile[ti]) < 0)
				{
					mx = (ti % dun.size.x) * 32;
					my = (ti / dun.size.x) * 32;
					break;
				}
			}
			MobData md;
			md.tag = "Bat";
			md.position.x = mx;
			md.position.y = my;
			rm.mobData.insertLast(md);
		}
	}
	
}

void WorldBuilder_buildDungeon(ScriptComponent @p, string dunName, string areaName, int w, int h, int roomTotal, int connectivity, int worldx, int worldy)
{

	p.setTextString("Building Dungeon...");
	p.suspend(1);
	
	array<HookData> hook;
	int rmid = 0;
	AreaData @ad = null;
	for (int k = 0; k < gAreaData.length(); ++k)
	{
		if (gAreaData[k].name == areaName)
		{
			@ad = gAreaData[k];
			break;
		}
	}
	
	array<int> tile(w * h, ad.baktile);
	
	Dungeon dun;
	dun.name = dunName;
	dun.size.x = w;
	dun.size.y = h;
	dun.startRoom = 0;
	dun.baktile = ad.baktile;
	
	array<string> uniqueRoom;
	
	// Starting room
	
	Room rm;
	rm.id = rmid++;
	rm.visited = true;
	//auto @rd = WorldBuilder_getRoom(p, ad, uniqueRoom);
	auto @rd = ad.roomData[0];
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
	 
	// TEMP: Starting position
	
	dun.startPosition.x = (w/2 + rd.size.x/2) * 32;
	dun.startPosition.y = (h/2 + rd.size.y/2 + 1) * 32;
	dun.worldPosition.x = worldx;
	dun.worldPosition.y = worldy;
	
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
		rm.size = rd.size;
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
		
		for (int i = 0; i < rd.hookData.length(); ++i)
		{
			HookData hd;
			hd.pos.x = rd.hookData[i].pos.x + rl;
			hd.pos.y = rd.hookData[i].pos.y + rt;
			hd.orient = rd.hookData[i].orient;
			hd.roomid = rm.id;
			if (hd.pos.x != hda.pos.x or hd.pos.y != hda.pos.y) hook.insertLast(hd);
		}
		hook.removeAt(hookIndex);
		
		dun.room.insertLast(rm);
		
		++roomCounter;
	}
	
	// Connectivity
		
	int connectCount = 0;
	int tryCount = 0;
	while(connectCount < connectivity and tryCount < roomTotal * 20)
	{
		++tryCount;
		
		// Select two hooks that don't share the same room id
		
		auto @ha = hook[p.randomRange(0, hook.length())];
		HookData @hb = null;
		while(true)
		{
			@hb = hook[p.randomRange(0, hook.length())];
			if (hb !is ha and ha.roomid != hb.roomid) break;
		}
		
		// Create cur start and determine starting direction and destination
		
		
		int destx = hb.pos.x;
		int desty = hb.pos.y;
		string destOrient = hb.orient;
		
		if (destOrient == "n")
		{
			desty -= 2;
		}
		else if (destOrient == "s")
		{
			desty += 1; 
		}
		else if (destOrient == "w")
		{
			destx -= 2;
		}
		else if (destOrient == "e")
		{
			destx += 1;
		}
		
		Coord cur = ha.pos;
		int mx = 0;
		int my = 0;
		string orient;
		
		if (ha.orient == "n")
		{
			cur.y -= 2;
			int dx = destx - cur.x;
			if (dx < 0)
			{
				orient = "w";
				mx = -1;
			}
			else
			{
				orient = "e";
				mx = 1;
			}
		}
		else if (ha.orient == "s")
		{
			cur.y += 1;
			int dx = destx - cur.x;
			if (dx < 0)
			{
				orient = "w";
				mx = -1;
			}
			else
			{
				orient = "e";
				mx = 1;
			}
		}
		else if (ha.orient == "w")
		{
			cur.x -= 2;
			int dy = desty - cur.y;
			if (dy < 0)
			{
				orient = "n";
				my = -1;
			}
			else
			{
				orient = "s";
				my = 1;
			}
		}
		else if (ha.orient == "e")
		{
			cur.x += 1;
			int dy = desty - cur.y;
			if (dy < 0)
			{
				orient = "n";
				my = -1;
			}
			else
			{
				orient = "s";
				my = 1;
			}
		}
		
		// Scan loop
		
		bool pass = true;
		array<Coord> path;
		while(true)
		{
			// Bounds & scan
			int x = cur.x;
			int y = cur.y;
			
			
			if (x < 1 or x > w - 3 or y < 1 or y > h - 3)
			{
				pass = false;
				break;
			}
			
			for (int j = y; j < y + 2; ++j)
			{
				for (int i = x; i < x + 2; ++i)
				{
					int ti = j * w + i;
					if (tile[ti] != ad.baktile)
					{
						pass = false;
					}
				}
			}
			
			if (!pass) break;
			
			path.insertLast(cur);
			
			// Destination?
			
			if (x == destx and y == desty) break;
			
			// Reorient if necessary and move
			
			if (orient == "n" or orient == "s")
			{
				if (y == desty)
				{
					if (x > destx)
					{
						orient = "w";
						my = 0;
						mx = -1;
					}
					else
					{
						orient = "e";
						my = 0;
						mx = 1;
					}
				}
			}
			else
			{
				if (x == destx)
				{
					if (y > desty)
					{
						orient = "n";
						mx = 0;
						my = -1;
					}
					else
					{
						orient = "s";
						mx = 0;
						my = 1;
					}
				}
			}
			
			cur.x += mx;
			cur.y += my;
		}
		
		if (!pass) continue;
		
		// Build!
		++connectCount;
		
		array<int> passageTiles;
		
		// Walls
		
		for (int k = 0; k < path.length(); ++k)
		{
			Coord tl;
			tl.x = path[k].x - 1;
			tl.y = path[k].y - 1;
			for (int j = tl.y; j < tl.y + 4; ++j)
			{
				for (int i = tl.x; i < tl.x + 4; ++i)
				{
					int ti = j * w + i;
					tile[ti] = ad.wallTile;
					if (passageTiles.find(ti) < 0) passageTiles.insertLast(ti);
				}
			}
		}
		
		// Room data
		
		Room prm;
		prm.id = rmid++;
		prm.size.x = 0;
		prm.size.y = 0;
		prm.visited = false;
		prm.tpos = passageTiles;
		dun.room.insertLast(prm);
		
		// Floor;
		
		for (int k = 0; k < path.length(); ++k)
		{
			auto @tl = path[k];
			for (int j = tl.y; j < tl.y + 2; ++j)
			{
				for (int i = tl.x; i < tl.x + 2; ++i)
				{
					int ti = j * w + i;
					tile[ti] = ad.floorTile;
				}
			}
		}
		
		// Clear hooks
		
		int anchorA = ha.pos.y * w + ha.pos.x;
		tile[anchorA] = ad.floorTile;
		if (ha.orient == "n" or ha.orient == "s") tile[anchorA + 1] = ad.floorTile;
		else tile[anchorA + w] = ad.floorTile;
		
		int anchorB = hb.pos.y * w + hb.pos.x;
		tile[anchorB] = ad.floorTile;
		if (hb.orient == "n" or hb.orient == "s") tile[anchorB + 1] = ad.floorTile;
		else tile[anchorB + w] = ad.floorTile;
		
		// Door data
		
		DoorData pdd1;
		pdd1.rm1 = ha.roomid;
		pdd1.rm2 = prm.id;
		pdd1.pos = ha.pos;
		pdd1.orient = ha.orient;
		pdd1.opened = false;
		dun.doorData.insertLast(pdd1);
		
		DoorData pdd2;
		pdd2.rm1 = hb.roomid;
		pdd2.rm2 = prm.id;
		pdd2.pos = hb.pos;
		pdd2.orient = hb.orient;
		pdd2.opened = false;
		dun.doorData.insertLast(pdd2);
		
	}
	p.log("Area " + dun.name + " built. Rooms: " + roomTotal + ", Passages: " + connectCount);
	
	dun.tile = tile;
	dun.tileset = ad.tileset;
	
	// Add MobData
	
	WorldBuilder_addMobData(p, dun);
	
	gDungeon.insertLast(dun);
	
	array<string> dunData;
	dunData.insertLast("dunid");
	string sdid = "";
	sdid += gDungeon.length() - 1;
	dunData.insertLast(sdid);
	
	array<string> exitData;
	exitData.insertLast("dunindex");
	exitData.insertLast("" + (gDungeon.length() - 1));
	
	p.createSceneData(dunName, w * 32, h * 32, 100, 100);
	p.addSceneLayer(dunName, "terrain", false);
	p.addSceneLayer(dunName, "main", false);
	p.addSceneLayer(dunName, "HUD", true);
	p.addSceneDataEntity(dunName, "DungeonLogic", 1, true, "HUD", 0.0, 0.0, false, dunData);
	p.addSceneDataEntity(dunName, "AreaExit", 1, true, "main", dun.startPosition.x, dun.startPosition.y - 32, false, exitData);
	p.addSceneBase(dunName, "PlayBase");
	p.addSceneTilemap(dunName, ad.tileset, "terrain", w, h, tile);
}


