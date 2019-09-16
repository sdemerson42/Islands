void MapLogic_main(ScriptComponent @p)
{
	p.log("MapLogic OK");
	while(true)
	{
		int food = gMaster.getReg("food");
		p.setTextString("Food: " + food);
		p.suspend();
	}	
}