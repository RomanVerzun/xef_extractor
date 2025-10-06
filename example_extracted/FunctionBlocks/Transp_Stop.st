(* ======================================== *)
(* FUNCTION BLOCK: Transp_Stop *)
(* VERSION: 0.02 *)
(* Stop Transport *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;


(* -------- PROGRAM: Stop -------- *)
PROJECT.Transp[iterator].DO_Stop := TRUE;
PROJECT.Transp[iterator].DO_Start := FALSE;
PROJECT.Transp[iterator].MotorEnable := FALSE;
