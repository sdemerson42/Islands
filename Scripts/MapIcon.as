void MapIcon_main(ScriptComponent @p)
{

}

void MapIcon_onCollision(ScriptComponent @p, Entity @e, PhysicsComponent @pc)
{
	if (e.hasTag("MapWizard") and p.getReg("flag") != 1)
	{
		auto dname = p.getString(0);
		for (int i = 0; i < gDungeon.length(); ++i)
		{
			if (gDungeon[i].name == dname)
			{
				auto @dun = gDungeon[i];
				gMaster.setReg("destx", dun.startPosition.x);
				gMaster.setReg("desty", dun.startPosition.y);
				Master_prepareTransition(dname);
				p.setReg("flag", 1);
			}
		}
	}
}