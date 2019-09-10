void DungeonLogic_main(ScriptComponent @p)
{
	p.log("DungeonLogic OK");
	
	// Place doors
	
	
	
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
			break;
		}
	}
}