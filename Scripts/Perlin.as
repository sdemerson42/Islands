class Ivec
{
	Ivec() {}
	Ivec(int xx, int yy)
	{
		x = xx;
		y = yy;
	}
	int x;
	int y;
}

	

void Perlin_main(ScriptComponent @p)
{
	p.log("Perlin OK");
	p.setTextString("Building island...");
	p.suspend();

	int w = 300;
	int h = 300;

	auto pmap = Perlin_makeNoise(p, w, h, 25, 25);
	Perlin_simpleMask(pmap, 130, 0.0);
	
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
		
	p.createSceneData("Perlin", w * 32, h * 32, 100, 100);
	p.addSceneLayer("Perlin", "terrain", false);
	p.addSceneLayer("Perlin", "main", false);
	p.addSceneLayer("Perlin", "HUD", true);
	p.addSceneTilemap("Perlin", "U5", "terrain", w, h, tiles);
	p.addSceneEntity("Perlin", "Master", 1, true, "main", 0.0, 0.0, true);
	p.addSceneEntity("Perlin", "Wizard", 1, true, "main", wx, wy, false);
	//p.addSceneEntity("Perlin", "MapLogic", 1, true, "HUD", 0.0, 0.0, false);
	p.addSceneEntity("Perlin", "Scroll", 1, true, "main", wx - 32.0, wy - 32.0, false);
	p.addSceneEntity("Perlin", "SpellFrame", 1, true, "HUD", 30.0, 550.0, false);
	p.addSceneEntity("Perlin", "SpellIcon", 1, true, "HUD", 38.0, 558.0, false);
	
	p.changeScene("Perlin");
}

float Perlin_smooth(float x)
{
	return 3.0f*x*x - 2.0f*x*x*x;
}

float Perlin_lerp(float x0, float x1, float t)
{
	return x1 * t + x0 * (1 - t);
}


array<array<float>> Perlin_makeNoise(ScriptComponent @p, int w, int h, int cw, int ch)
{
	
	array<array<float>> pmap(w, array<float>(h));
	
	// Generate grid

	array<array<Ivec>> grid(w / cw + 1, array<Ivec>(h/ch + 1));

	for (int i = 0; i < grid.length(); ++i)
	{
		for (int j = 0; j < grid[0].length(); ++j)
		{
			int x = 0;
			int y = 0;
			while (x == 0 and y == 0)
			{
				x = p.randomRange(-1, 2);
				y = p.randomRange(-1, 2);
			}
			grid[i][j].x = x;
			grid[i][j].y = y;
		}
	}
	
	
	// pixel by pixel...

	float pmax = 0.0f;
	float pmin = 0.0f;

	for (int j = 0; j < h; ++j)
	{
		for (int i = 0; i < w; ++i)
		{
			int gx = i / cw;
			int gy = j / ch;

			auto gradA = grid[gx][gy];
			auto gradB = grid[gx + 1][gy];
			auto gradC = grid[gx][gy + 1];
			auto gradD = grid[gx + 1][gy + 1];

			Ivec vecA( i - gx * cw, j - gy * ch );
			Ivec vecB( i - (gx + 1) * cw, j - gy * ch );
			Ivec vecC( i - gx * cw, j - (gy + 1) * ch );
			Ivec vecD( i - (gx + 1) * cw, j - (gy + 1) * ch );

			// Dot products

			int r = gradA.x * vecA.x + gradA.y * vecA.y;
			int s = gradB.x * vecB.x + gradB.y * vecB.y;
			int t = gradC.x * vecC.x + gradC.y * vecC.y;
			int u = gradD.x * vecD.x + gradD.y * vecD.y;
			
			float tx = Perlin_smooth(float(i % cw) / float(cw - 1));
			float ty = Perlin_smooth(float(j % ch) / float(ch - 1));

			auto avgA = Perlin_lerp(r, s, tx);
			auto avgB = Perlin_lerp(t, u, tx);
			auto avgC = Perlin_lerp(avgA, avgB, ty);

			pmap[i][j] = avgC;

			if (avgC < pmin) pmin = avgC;
			if (avgC > pmax) pmax = avgC;
		}
	}
	
	
	// Normalize

	for (int i = 0; i < w; ++i)
	{
		for (int j = 0; j < h; ++j)
		{
			auto val = pmap[i][j];
			val = (val - pmin) / (pmax - pmin);
			pmap[i][j] = val;
		}
	}

	return pmap;

}

void Perlin_simpleMask(array<array<float>> @map, int r, float fillValue)
{
	int w = map.length();
	int h = map[0].length();
	int cx = w / 2;
	int cy = h / 2;

	for (int i = 0; i < w; ++i)
	{
		for (int j = 0; j < h; ++j)
		{
			int dx = i - cx;
			int dy = j - cy;
			auto dist = sqrt(dx * dx + dy * dy);
			if (dist > r)
			{ 
				map[i][j] = fillValue;
			}	
		}
	}
}
