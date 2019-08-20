void DeadTree_main(ScriptComponent @p)
{
	p.setComponentActive("particles", false);
}

void DeadTree_burn(ScriptComponent @p)
{	
	int alpha = 240;
	p.playSound("Boom", 10.0, false, 1);
	while(true)
	{
		p.setRenderColor(255, 20, 20, alpha);
		alpha -= 20;
		if (alpha == 0) p.despawn();
		p.suspend();
	}
}

void DeadTree_onCollision(ScriptComponent @p, Entity @e, PhysicsComponent @pc)
{
	if (e.hasTag("Fireball") and p.getReg("lock") == 0)
	{
		p.setReg("lock", 1);
		p.setRenderColor(255, 20, 20, 240);
		p.setComponentActive("particles", true);
		p.setMainFunction("burn");
	}
}