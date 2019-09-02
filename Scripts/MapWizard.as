ScriptComponent @gMapWizard;

void MapWizard_main(ScriptComponent @p)
{
	// Init happens here if necessary
	@gMapWizard = p; 
	p.setReg("food", 100);
	p.setReg("mcounter", 0);
	p.setMainFunction("mainState");

}

void MapWizard_mainState(ScriptComponent @p)
{
	
	while(true)
	{
		auto pos = p.position();
		p.setViewCenter(pos.x, pos.y);
		// Controls

		auto input = p.input();
		auto moved = MapWizard_move(p, input);
		
		if (moved)
		{
			int val = p.modReg("mcounter", 1);
			if (val >= 180)
			{
				p.setReg("mcounter", 0);
				p.modReg("food", -1);
			}
		}

		p.suspend();
	}
	
}

bool MapWizard_move(ScriptComponent @p, const InputEvent &input)
{
	// Movement
	
	bool moved = true;
	auto pos = p.position();
	int ut = p.tileAtPosition(pos.x + 12.0, pos.y + 12.0);
	float speed = 3.0;
	if (ut == 3 or ut == 9 or ut == 11) speed = 2.0;
	else if (ut == 12) speed = 1.0;

	float moveX = 0;
	float moveY = 0;
	
	if (input.stickLeftX < -0.1 or input.stickLeftX > 0.1)
	{
		moveX = input.stickLeftX;	
	} 
	if (input.stickLeftY < -0.1 or input.stickLeftY > 0.1)
	{
		moveY = input.stickLeftY;	
	}

	if (moveX == 0 and moveY == 0)
	{
		p.playAnimation("idle");
		moved = false;
	}
	else
	{
		float mag = sqrt(moveX **2 + moveY ** 2);
		moveX /= mag;
		moveY /= mag;
		moveX *= speed;
		moveY *= speed;
		p.playAnimation("walking");
	}
	p.setMomentum(moveX, moveY);
	return moved;
}