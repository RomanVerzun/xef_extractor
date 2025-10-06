(* ======================================== *)
(* FUNCTION BLOCK: Valve_Stop *)
(* VERSION: 0.04 *)
(* Stop Valve *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;


(* -------- PROGRAM: StopValve -------- *)
Project.Valve[iterator].DO_Motor_Enable := False;
Project.Valve[iterator].DO_Motor_Open := False;
Project.Valve[iterator].DO_Motor_Close := False;
PROJECT.Valve[iterator].Half_sec_Timer := False;
PROJECT.Valve[iterator].Timeout_Timer := False;
