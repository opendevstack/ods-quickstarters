// ***********************************************
// This commands.js contains custom commands and
// overwrite existing commands.
//
// For more information about custom commands
// please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************

import { addGenericLoginCommands } from './generic-login';
import { addMsalv2LoginCommand } from './msalv2-login';

addGenericLoginCommands();
addMsalv2LoginCommand();
