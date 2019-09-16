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
		Master_prepareTransition("World");
		p.setReg("flag", 1);
	}
}