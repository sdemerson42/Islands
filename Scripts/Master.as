ScriptComponent @gMaster;

void Master_main(ScriptComponent @p)
{
	@gMaster = p;

	p.setReg("wizardSpell", -1);
	p.setReg("gameState", 0);
	
	// Test regs
	
	p.setReg("food", 100);
	
	p.log("Master OK");
	
	// Scene transitions
	
	while(true)
	{
		if (p.getReg("gameState") != 0) Master_transition();
		p.suspend();
	}
}

void Master_wizardInit(ScriptComponent @p, ScriptComponent @wiz)
{
	string spell = "none";
	int spellIndex = p.getReg("wizardSpell");
	
	if (0 == spellIndex) spell = "fireball";

	Wizard_setSpell(wiz, spell);	
}

void Master_prepareTransition(string scene)
{
	gMaster.setString(0, scene);
	gMaster.setReg("gameState", -1);
	auto handle = gMaster.forceSpawn("Black", "HUD");
	handle.setRenderColor(255, 255, 255, 0);
	gMaster.setReg("blackAlpha", 0);
}

void Master_transition()
{
	int state = gMaster.getReg("gameState");
	if (state == -1)
	{
		int alpha = gMaster.modReg("blackAlpha", 10);
		auto black = gMaster.getScriptByTag("Black");
		black.setRenderColor(255, 255, 255, alpha);
		if (alpha == 250)
		{
			gMaster.setReg("gameState", -2);
			gMaster.changeScene(gMaster.getString(0));
		}
	}
	else if (state == -2)
	{
		auto handle = gMaster.forceSpawn("Black", "HUD");
		handle.setRenderColor(255, 255, 255, 250);
		gMaster.setReg("gameState", -3);
	}
	else if (state == -3)
	{
		int alpha = gMaster.modReg("blackAlpha", -10);
		auto black = gMaster.getScriptByTag("Black");
		black.setRenderColor(255, 255, 255, alpha);
		if (alpha == 0)
		{
			gMaster.setReg("gameState", 0);
		}
	}
}
