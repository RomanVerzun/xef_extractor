(* ======================================== *)
(* FUNCTION BLOCK: Write_log *)
(* VERSION: 0.02 *)
(* Write Log function *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Message : STRING;


(* -------- PROGRAM: Write_log -------- *)
Project.Logs.Messages[Project.Logs.LogIndex].LogNum := Project.Logs.LogCount;
Project.Logs.Messages[Project.Logs.LogIndex].Message := Message;

Project.Logs.LogCount := Project.Logs.LogCount + 1;
Project.Logs.LogIndex := Project.Logs.LogIndex + 1;
IF PROJECT.Logs.LogIndex > 100 THEN
	Project.Logs.LogIndex := 0;
END_IF;
