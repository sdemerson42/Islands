void Scroll_main(ScriptComponent @p)
{
	p.setSleep(true);
}

void Scroll_onCollision(ScriptComponent @p, Entity @e, PhysicsComponent @pc)
{
	if (e.hasTag("Wizard"))
	{
		gMaster.setReg("wizardSpell", 0);
		Wizard_setSpell(e.scriptComponent(), "fireball");
		//p.removeSceneEntity("Perlin", "Scroll");
		auto handle = p.getScriptByTag("SpellIcon");
		if (handle !is null)
		{
			SpellIcon_setImage(handle);
		}
		p.despawn();
	}
}