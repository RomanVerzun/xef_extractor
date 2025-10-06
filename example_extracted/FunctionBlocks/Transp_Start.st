(* ======================================== *)
(* FUNCTION BLOCK: Transp_Start *)
(* VERSION: 0.02 *)
(* Start Transport *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;


(* -------- PROGRAM: Start -------- *)
PROJECT.Transp[iterator].DO_Stop := FALSE;
PROJECT.Transp[iterator].DO_Start := TRUE;
PROJECT.Transp[iterator].MotorEnable := TRUE;
