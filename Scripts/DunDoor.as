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
				
				// Spawn mobs
				
				if (!rm.visited)
				{
					auto @md = rm.mobData;
					for (int k = 0; k < md.length(); ++k)
					{
						auto handle = p.forceSpawn(md[k].tag, "main");
						if (handle !is null) handle.setPosition(md[k].position.x, md[k].position.y);
					}
				}
				
				++clearCount;
				if (clearCount == 2) break;
			}
		}
		
		// Set door data to opened
		for (int i = 0; i < dun.doorData.length(); ++i)
		{
			auto @dd = dun.doorData[i];
			if (dd.rm1 == rm1 and dd.rm2 == rm2)
			{
				dd.opened = true;
				break;
			}
		}
		
		// Spawn routines
		
		Room @rmh1 = null;
		Room @rmh2 = null;
		
		for (int k = 0; k < dun.room.length(); ++k)
		{
			if (dun.room[k].id == rm1) @rmh1 = dun.room[k];
			if (dun.room[k].id == rm2) @rmh2 = dun.room[k];
		}
		
		// Place doors
		
		for (int i = 0; i < dun.doorData.length(); ++i)
		{
			auto @dd = dun.doorData[i];
			if (((dd.rm1 == rm1 or dd.rm2 == rm1) and !rmh1.visited) or ((dd.rm1 == rm2 or dd.rm2 == rm2) and !rmh2.visited))
			{
				if (!dd.opened and !dd.spawned)
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
					dd.spawned = true;
				}
			}
		}
		
		rmh1.visited = true;
		rmh2.visited = true;
		
		p.despawn();
	}
}