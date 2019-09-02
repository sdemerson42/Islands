void MapLogic_main(ScriptComponent @p)
{
	p.log("MapLogic OK");
	while(true)
	{
		if (gMapWizard !is null)
		{
			int food = gMapWizard.getReg("food");
			p.setTextString("Food: " + food);
		}
		p.suspend();
	}	
}