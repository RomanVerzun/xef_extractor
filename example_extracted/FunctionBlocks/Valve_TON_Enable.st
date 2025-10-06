(* ======================================== *)
(* FUNCTION BLOCK: Valve_TON_Enable *)
(* VERSION: 0.13 *)
(* EMULATE! TON for Valve emulation *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;
  State : BOOL;
  Time_wait : DINT;

(* PRIVATE VARIABLES *)
  Ton_0 : TON;
  Ton_1 : TON;
  Write_log : Write_log;


(* -------- PROGRAM: Ton -------- *)
CASE iterator OF
0: Ton_0 (IN := State,
	PT := DINT_TO_TIME(Time_wait),
	Q => PROJECT.Emulate_Valve[Iterator].Valve_Move,
	ET => PROJECT.Emulate_Valve[Iterator].Elapsed_Time); 
1: Ton_1 (IN := STATE,
	PT := DINT_TO_TIME(Time_wait),
	Q => PROJECT.Emulate_Valve[iterator].Valve_Move,
	ET =>  PROJECT.Emulate_Valve[iterator].Elapsed_Time); 
END_CASE;
