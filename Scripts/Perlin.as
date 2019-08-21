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
}

float Perlin_smooth(float x)
{
	return 3.0f*x*x - 2.0f*x*x*x;
}

float Perlin_lerp(float x0, float x1, float t)
{
	return x1 * t + x0 * (1.0 - t);
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

void Perlin_circularMask(array<array<float>> @map, int r)
{
	int w = map.length();
	int h = map[0].length();
	int cx = w / 2;
	int cy = h / 2;
	float maxDist = sqrt(cx * cx + cy * cy);
	

	for (int i = 0; i < w; ++i)
	{
		for (int j = 0; j < h; ++j)
		{
			int dx = i - cx;
			int dy = j - cy;
			auto dist = sqrt(dx * dx + dy * dy);
			if (dist > r)
			{
				float t = (dist - maxDist) / (float(r) - maxDist);
				map[i][j] = map[i][j] * t;
			}	
		}
	}
}

void Perlin_rectangularMask(array<array<float>> @map, int rw)
{
	int w = map.length();
	int h = map[0].length();
	
	for (int k = 0; k < rw; ++k)
	{
		float t = float(k) / float(rw - 1);
		
		// R, D, L, U
		for (int i = k; i < w - (1 + k); ++i)
		{
			int j = k;
			map[i][j] *= t;
		}
		
		for (int j = k; j < h - (1 + k); ++j)
		{
			int i = w - (1 + k);
			map[i][j] *= t;
		}
		
		for (int i = w - (1 + k); i >= k; --i)
		{
			int j = h - (1 + k);
			map[i][j] *= t;
		}
		
		for (int j = h - (1 + k); j >= k; --j)
		{
			int i = k;
			map[i][j] *= t;
		}
		
	}

}
