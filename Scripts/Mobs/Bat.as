void Bat_main(ScriptComponent @p)
{
	Bat_changeDir(p);
}

void Bat_changeDir(ScriptComponent @p)
{
	int x = 0;
	int y = 0;
	while(x == 0 and y == 0)
	{
		x = p.randomRange(-10, 11);
		y = p.randomRange(-10, 11);
	}
	float mx = float(x);
	float my = float(y);
	float mag = sqrt(mx*mx + my*my);
	mx = mx / mag * 2.0;
	my = my / mag * 2.0;
	p.setMomentum(mx, my);
}

void Bat_onCollision(ScriptComponent @p, Entity @e, PhysicsComponent @pc)
{
	if (e.hasTag("Fireball"))
	{
		p.despawn();
	}
	else
	{
		Bat_changeDir(p);
	}
}