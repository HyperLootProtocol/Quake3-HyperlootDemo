//
//  HyperlootWeapons.c
//  Quake3
//
//  Created by valery_vaskabovich on 8/10/18.
//

#include "HyperlootWeapons.h"
#include "client.h"
#include "qcommon.h"

void LoadTokenizedRocketLauncher(void);
void LoadTokenizedQuadDamage(void);
void LoadTokenizedInvisibility(void);

void LoadTokenizedRocketLauncher() {
	Cmd_ExecuteString("sv_cheats 1");
	Cmd_ExecuteString("give rocket launcher");
}

void LoadTokenizedQuadDamage() {
	Cmd_ExecuteString("sv_cheats 1");
	Cmd_ExecuteString("give quad damage");
}

void LoadTokenizedInvisibility() {
	Cmd_ExecuteString("sv_cheats 1");
	Cmd_ExecuteString("give invisibility");
}
