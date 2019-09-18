void DungeonLogic_main(ScriptComponent @p)
{
	p.log("DungeonLogic OK");
	
	
	auto @dun = gDungeon[p.getReg("dunid")];
	int sid = dun.startRoom;
		
	// Place doors
	
	for (int i = 0; i < dun.doorData.length(); ++i)
	{
		auto @dd = dun.doorData[i];
		if ((dd.rm1 == sid or dd.rm2 == sid) or dd.spawned)
		{
			if (!dd.opened)
			{
				if (dd.orient == "n" or dd.orient == "s")
				{
					auto handle = p.forceSpawn("DunDoorH", "main");
					handle.setPosition(dd.pos.x * 32, dd.pos.y * 32);
					handle.setReg("dunid", p.getReg("dunid"));
					handle.setReg("rm1", dd.rm1);
					handle.setReg("rm2", dd.rm2);
				}
				else
				{
					auto handle = p.forceSpawn("DunDoorV", "main");
					handle.setPosition(dd.pos.x * 32, dd.pos.y * 32);
					handle.setReg("dunid", p.getReg("dunid"));
					handle.setReg("rm1", dd.rm1);
					handle.setReg("rm2", dd.rm2);
				}
			}
		}
	}
	
	// Apply fog of war

	for (int i = 0; i < dun.room.length(); ++i)
	{
		auto @rm = dun.room[i];
		for (int j = 0; j < rm.tpos.length(); ++j)
		{
			p.setTile(rm.tpos[j], dun.baktile);
		}
	}
	
	// Clear visited rooms
	for (int i = 0; i < dun.room.length(); ++i)
	{
		auto @rm = dun.room[i];
		if (rm.visited or rm.id == sid)
		{
			for (int j = 0; j < rm.tpos.length(); ++j)
			{
				p.setTile(rm.tpos[j], dun.tile[rm.tpos[j]]);
			}
		}
	}
	
	// Spawn active mobs
	
	for (int i = 0; i < dun.spawnedMobs.length(); ++i)
	{
		auto @mob = dun.spawnedMobs[i];
		auto handle = p.forceSpawn(mob.tag, "main");
		if (handle !is null)
		{
			handle.setPosition(mob.position.x, mob.position.y);
		}
	}
}