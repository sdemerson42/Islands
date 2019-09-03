void DunDoor_main(ScriptComponent @p)
{

}

void DunDoor_onCollision(ScriptComponent @p, Entity @e, PhysicsComponent@pc)
{
	if (e.hasTag("Wizard"))
	{
		// Clear fog of war
		
		auto @dun = gDungeon[p.getReg("dunid")];
		int rm1 = p.getReg("rm1");
		int rm2 = p.getReg("rm2");
		int clearCount = 0;
		
		for (int i = 0; i < dun.room.length(); ++i)
		{
			auto @rm = dun.room[i];
			if (rm.id == rm1 or rm.id == rm2)
			{
				for (int j = 0; j < rm.tpos.length(); ++j)
				{
					p.setTile(rm.tpos[j], dun.tile[rm.tpos[j]]);
				}
				++clearCount;
				if (clearCount == 2) break;
			}
		}
		
		p.despawn();
	}
}