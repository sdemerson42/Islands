void SpellIcon_main(ScriptComponent @p)
{
	SpellIcon_setImage(p);
	p.setSleep(true);
}

void SpellIcon_setImage(ScriptComponent @p)
{
	auto spellIndex = gMaster.getReg("wizardSpell");
	if (spellIndex == -1) p.setRenderFrame(0.0, 0.0, 1.0, 1.0);
	if (spellIndex == 0) p.setRenderFrame(0.0, 16.0, 16.0, 16.0);
}