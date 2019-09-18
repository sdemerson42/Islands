void AreaExit_main(ScriptComponent @p)
{

}

void AreaExit_onCollision(ScriptComponent @p, Entity @e, PhysicsComponent @pc)
{
	if (e.hasTag("Wizard") and p.getReg("flag") != 1)
	{
		auto dunindex = p.getReg("dunindex");
		auto @dun = gDungeon[dunindex];
		gMaster.setReg("destx", dun.worldPosition.x);
		gMaster.setReg("desty", dun.worldPosition.y);
		
		// Record spawned mob data
		
		dun.spawnedMobs = array<MobData>();
		auto mobs = p.getAllScriptsByTag("Mob");
		for (int i = 0; i < mobs.length(); ++i)
		{
			auto @scr = mobs[i];
			if (scr.entityActive())
			{
				auto pos = scr.position();
				auto tag = scr.tag();
				MobData md;
				md.tag = tag;
				md.position.x = pos.x;
				md.position.y = pos.y;
				dun.spawnedMobs.insertLast(md);
			}
		}
		
		Master_prepareTransition("World");
		p.setReg("flag", 1);
	}
}