void ClueChest_main(ScriptComponent @p)
{
	while(true)
	{
		int active = p.getReg("active");
		if (active == 0)
		{
			p.suspend();
			continue;
		}
		else if (active == 1)
		{
			auto input = p.input();
			if (input.a == 1)
			{
				int node = p.modReg("node", 1);
				if (node == p.getReg("nodeTotal"))
				{
					Master_endDialogue();
					p.despawn();
					return;
				}
				else
				{
					Master_continueDialogue(p.getString(node));
				}
			}	
		}
		p.suspend();
	}
}

void ClueChest_onCollision(ScriptComponent @p, Entity @e, PhysicsComponent @pc)
{
	if (p.getReg("active") > 0) return;
	if (e.hasTag("Wizard") or e.hasTag("MapWizard"))
	{
		p.setReg("active", 1);
		Master_beginDialogue(p.getString(0));
	}
}