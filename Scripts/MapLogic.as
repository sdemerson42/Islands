void MapLogic_main(ScriptComponent @p)
{
	p.log("MapLogic OK");
	while(true)
	{
		if (gMapWizard !is null)
		{
			auto pos = gMapWizard.position();
			p.setTextString("(" + pos.x + ", " + pos.y + ")");
		}
		p.suspend(60);
	}	
}