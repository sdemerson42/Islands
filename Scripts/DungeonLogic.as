void DungeonLogic_main(ScriptComponent @p)
{
	p.log("DungeonLogic OK");
	
	// Apply fog of war
	
	auto @dun = gDungeon[p.getReg("dunid")];
	int sid = dun.startRoom;
	
	for (int i = 0; i < dun.room.length(); ++i)
	{
		auto @rm = dun.room[i];
		for (int j = 0; j < rm.tpos.length(); ++j)
		{
			p.setTile(rm.tpos[j], 255);
		}
	}
	
	// Clear startRoom
	for (int i = 0; i < dun.room.length(); ++i)
	{
		auto @rm = dun.room[i];
		if (rm.id == dun.startRoom)
		{
			for (int j = 0; j < rm.tpos.length(); ++j)
			{
				p.setTile(rm.tpos[j], dun.tile[rm.tpos[j]]);
			}
			break;
		}
	}
}