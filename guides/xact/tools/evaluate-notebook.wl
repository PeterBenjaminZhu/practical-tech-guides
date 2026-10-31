Print["ARGUMENTS=", $ScriptCommandLine];
If[Length[$ScriptCommandLine] < 3, Print["用法：evaluate-notebook.wl notebook output-directory"]; Exit[2]];
source = ExpandFileName[$ScriptCommandLine[[-2]]];
destination = ExpandFileName[$ScriptCommandLine[[-1]]];
If[! FileExistsQ[source], Print["Notebook 不存在：", source]; Exit[2]];
If[DirectoryQ[destination], Print["证据目录已经存在：", destination]; Exit[2]];
CreateDirectory[destination, CreateIntermediateDirectories -> True];
SetDirectory[destination];
Print["SOURCE=", source];
Print["VERSION=", $Version];
Print["SYSTEM=", $SystemID];
Print["START=", DateString[Now, "ISODateTime"]];
notebookExpression = Get[source];
sourceCells = Cases[notebookExpression[[1]], item:Cell[_, style_String, ___] /; ! MemberQ[{"Output", "Print", "Message"}, style] :> item, Infinity];
inputCount = Count[sourceCells, Cell[BoxData[_], "Input", ___]];
If[inputCount == 0, Print["FAILED: Notebook 没有可执行 Input。"]; Exit[1]];
evaluatedCells = {};
Do[
  AppendTo[evaluatedCells, cell];
  If[MatchQ[cell, Cell[BoxData[_], "Input", ___]],
    input = cell[[1, 1]];
    Print["INPUT=", ToString[input, InputForm]];
    evaluationInput = If[ListQ[input], RowBox[input], input];
    result = Check[ToExpression[evaluationInput, If[StringQ[input], InputForm, StandardForm]], Print["FAILED: Input 发出 message：", ToString[$MessageList, InputForm]]; Exit[1]];
    If[result =!= Null,
      Print["OUTPUT=", ToString[result, InputForm]];
      boxes = Check[UsingFrontEnd[ToBoxes[result, StandardForm]], Print["FAILED: Output 格式化发出 message。"]; Exit[1]];
      If[! FreeQ[boxes, $Failed], Print["FAILED: Output 含有 $Failed。"]; Exit[1]];
      AppendTo[evaluatedCells, Cell[BoxData[boxes], "Output"]]
    ]
  ],
  {cell, sourceCells}
];
UsingFrontEnd[
  notebook = NotebookPut[ReplacePart[notebookExpression, 1 -> evaluatedCells], Visible -> False];
  serializedExpression = NotebookGet[notebook];
  NotebookClose[notebook];
];
outputExpression = Replace[serializedExpression, Notebook[cells_, options___] :> Notebook[cells, Sequence @@ DeleteCases[{options}, HoldPattern[Visible -> _] | HoldPattern[Visible :> _]], Visible -> True]];
outputNotebook = FileNameJoin[{destination, FileNameTake[source]}];
Check[UsingFrontEnd[Export[outputNotebook, outputExpression, "NB"]], Print["FAILED: NB 序列化发出 message。"]; Exit[1]];
If[! FileExistsQ[outputNotebook], Print["FAILED: 没有保存 Notebook。"]; Exit[1]];
savedExpression = Get[outputNotebook];
savedVisibility = Replace[savedExpression, Notebook[_, options___] :> (Visible /. {options})];
heldInput[boxes_] := ToExpression[If[ListQ[boxes], RowBox[boxes], boxes], If[StringQ[boxes], InputForm, StandardForm], HoldComplete];
inputExpressions[expression_] := heldInput /@ Cases[expression, Cell[BoxData[boxes_], "Input", ___] :> boxes, Infinity];
inputExpressionsUnchanged = SameQ[inputExpressions[notebookExpression], inputExpressions[savedExpression]];
If[! TrueQ[savedVisibility] || ! TrueQ[inputExpressionsUnchanged], Print["FAILED: 保存后的 Visible 或 Input 不符合要求。", {savedVisibility, inputExpressionsUnchanged}]; Exit[1]];
Export[FileNameJoin[{destination, "save-metadata.json"}], <|"format" -> "NB", "savedVisible" -> savedVisibility, "inputExpressionsUnchanged" -> inputExpressionsUnchanged|>, "RawJSON"];
Print["SAVED_VISIBLE=", savedVisibility];
Print["INPUT_EXPRESSIONS_UNCHANGED=", inputExpressionsUnchanged];
Print["END=", DateString[Now, "ISODateTime"]];
If[! TrueQ[Global`allChecksPassed], Print["FAILED: allChecksPassed 未得到 True。"]; Exit[1]];
Export[FileNameJoin[{destination, "results.json"}], Global`caseResults, "RawJSON"];
Print["ALL_CHECKS_PASSED=True"];
Exit[0];
