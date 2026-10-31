If[Length[$ScriptCommandLine] < 3, Print["用法：inspect-notebooks.wl notebook-directory output-json"]; Exit[2]];
notebookRoot = ExpandFileName[$ScriptCommandLine[[-2]]];
outputPath = ExpandFileName[$ScriptCommandLine[[-1]]];
If[FileExistsQ[outputPath], Print["检查结果已经存在：", outputPath]; Exit[2]];
files = Sort[FileNames["*.nb", notebookRoot, Infinity]];
If[Length[files] == 0, Print["目录中没有 Notebook：", notebookRoot]; Exit[1]];
heldInput[boxes_] := ToExpression[If[ListQ[boxes], RowBox[boxes], boxes], If[StringQ[boxes], InputForm, StandardForm], HoldComplete];
audit = Table[
  expression = Get[file];
  inputs = Cases[expression, Cell[BoxData[boxes_], "Input", ___] :> boxes, Infinity];
  outputs = Cases[expression, Cell[BoxData[boxes_], "Output", ___] :> boxes, Infinity];
  heldInputs = heldInput /@ inputs;
  heldOutputs = heldInput /@ outputs;
  nullLists = Count[heldOutputs, HoldComplete[values_List] /; Length[values] > 0 && And @@ (SameQ[#, Null] & /@ values)];
  <|"case" -> FileBaseName[file], "fileSHA256" -> FileHash[file, "SHA256", "HexString"], "inputCount" -> Length[inputs], "outputCount" -> Length[outputs], "inputSHA256" -> Hash[heldInputs, "SHA256", "HexString"], "hasFailedText" -> StringContainsQ[ToString[outputs, InputForm], "$Failed"], "nullListOutputCount" -> nullLists|>,
  {file, files}
];
Export[outputPath, <|"version" -> $Version, "timestamp" -> DateString[Now, "ISODateTime"], "notebooks" -> audit|>, "RawJSON"];
Print[ToString[audit, InputForm]];
Exit[0];
