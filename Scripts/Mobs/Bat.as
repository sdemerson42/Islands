void Bat_main(ScriptComponent @p)
{

}

void Bat_onCollision(ScriptComponent @p, Entity @e, PhysicsComponent @pc)
{
	if (e.hasTag("Fireball"))
	{
		p.despawn();
	}
}