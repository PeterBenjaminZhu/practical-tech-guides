(* 仅用于 AdS 坐标关系的独立核验；教学计算保存在四个 AdS Notebook 中。 *)
$HistoryLength = 0;
guideDirectory = DirectoryName[DirectoryName[$InputFileName]];
examplesDirectory = FileNameJoin[{guideDirectory, "examples"}];
outputDirectory = FileNameJoin[{guideDirectory, "outputs"}];
Print["ADS_COORDINATE_REVIEW_START | ", System`$Version];
requireTrue[value_, label_] := If[!TrueQ[value], Print["FAILED | ", label]; Quit[1]];
zeroQ[value_, assumptions_] := AllTrue[Flatten[{FullSimplify[value, assumptions]}], TrueQ[# === 0] &];
jacobian[map_List, coordinates_List] := Outer[D, map, coordinates];
pullback[metric_?MatrixQ, map_List, coordinates_List] := Transpose[jacobian[map, coordinates]] . metric . jacobian[map, coordinates];
poincareEmbedding[coordinateValues_List] := Module[{poincareTime, spatial, poincareZ},
  poincareTime = First[coordinateValues];
  spatial = coordinateValues[[2 ;; -2]];
  poincareZ = Last[coordinateValues];
  Join[{(L^2 + poincareZ^2 + spatial . spatial - poincareTime^2)/(2 poincareZ), L poincareTime/poincareZ}, L spatial/poincareZ, {(L^2 - poincareZ^2 - spatial . spatial + poincareTime^2)/(2 poincareZ)}]
];
inversePoincare[ambientValues_List] := Join[{L ambientValues[[2]]/(First[ambientValues] + Last[ambientValues])}, L ambientValues[[3 ;; -2]]/(First[ambientValues] + Last[ambientValues]), {L^2/(First[ambientValues] + Last[ambientValues])}];
readNotebookMetric[caseName_, replacements_List] := Module[{path, notebook, boxes, heldInputs, assignments},
  path = FileNameJoin[{examplesDirectory, caseName, caseName <> ".nb"}];
  requireTrue[FileExistsQ[path], "missing Notebook: " <> caseName];
  notebook = Get[path];
  boxes = Cases[notebook, Cell[BoxData[input_], "Input", ___] :> input, Infinity];
  heldInputs = Table[ToExpression[If[ListQ[input], RowBox[input], input], If[StringQ[input], InputForm, StandardForm], HoldComplete], {input, boxes}];
  assignments = Cases[heldInputs, HoldPattern[Set[Global`metricMatrix, right_]] :> HoldComplete[right], Infinity];
  requireTrue[Length[assignments] === 1, "one metricMatrix assignment: " <> caseName];
  ReleaseHold[First[assignments]] /. replacements
];
reviewDimension[dimension_Integer] := Module[
  {angles, unitDirection, sphereMetric, poincareCoordinates, globalCoordinates, arealCoordinates, compactCoordinates, boundaryCoordinates, ambientMetric, ambientVariables, poincareMap, globalMap, expectedPoincareMetric, expectedGlobalMetric, expectedArealMetric, globalDenominator, commonAssumptions, poincareAssumptions, globalAssumptions, arealAssumptions, compactAssumptions, boundaryAssumptions, inverseGlobal, notebookPoincareMetric, notebookGlobalMetric, reconstructedAmbient, ambientQuadric, ambientAssumptions, arealToGlobal, compactToGlobal, compactMetric, expectedCompactMetric, boundaryIndices, globalBoundaryMetric, poincareBoundaryMetric, boundaryDenominator, boundaryPoincareMap, expectedBoundaryMap, boundaryPullback, cylinderMetric, checks, notebookHashes, notebookNames, coordinateReplacements, reviewIndex, commonPullback},
  If[dimension === 4,
    angles = {theta, phi};
    unitDirection = {Sin[theta] Cos[phi], Sin[theta] Sin[phi], Cos[theta]};
    sphereMetric = DiagonalMatrix[{1, Sin[theta]^2}];
    poincareCoordinates = {tp, x, y, z},
    requireTrue[dimension === 5, "dimension 4 or 5 required"];
    angles = {chi, theta, phi};
    unitDirection = {Sin[chi] Sin[theta] Cos[phi], Sin[chi] Sin[theta] Sin[phi], Sin[chi] Cos[theta], Cos[chi]};
    sphereMetric = DiagonalMatrix[{1, Sin[chi]^2, Sin[chi]^2 Sin[theta]^2}];
    poincareCoordinates = {tp, x, y, w, z}
  ];
  globalCoordinates = Join[{tau, rho}, angles];
  arealCoordinates = Join[{tg, radial}, angles];
  compactCoordinates = Join[{tau, compactRadial}, angles];
  boundaryCoordinates = Join[{tau}, angles];
  ambientMetric = DiagonalMatrix[Join[{-1, -1}, ConstantArray[1, dimension - 1]]];
  poincareMap = poincareEmbedding[poincareCoordinates];
  globalMap = Join[{L Cosh[rho] Cos[tau], L Cosh[rho] Sin[tau]}, L Sinh[rho] unitDirection];
  expectedPoincareMetric = L^2/z^2 DiagonalMatrix[Join[{-1}, ConstantArray[1, dimension - 1]]];
  expectedGlobalMetric = DiagonalMatrix[Join[{-L^2 Cosh[rho]^2, L^2}, L^2 Sinh[rho]^2 Diagonal[sphereMetric]]];
  expectedArealMetric = DiagonalMatrix[Join[{-(1 + radial^2/L^2), 1/(1 + radial^2/L^2)}, radial^2 Diagonal[sphereMetric]]];
  poincareAssumptions = L > 0 && z > 0 && Element[poincareCoordinates, Reals];
  globalAssumptions = L > 0 && rho > 0 && 0 < theta < Pi && Element[globalCoordinates, Reals] && If[dimension === 5, 0 < chi < Pi, True];
  arealAssumptions = L > 0 && radial > 0 && 0 < theta < Pi && Element[arealCoordinates, Reals] && If[dimension === 5, 0 < chi < Pi, True];
  globalDenominator = L Cosh[rho] Cos[tau] + L Sinh[rho] Last[unitDirection];
  commonAssumptions = globalAssumptions && -Pi < tau < Pi && globalDenominator > 0;
  compactAssumptions = L > 0 && 0 < compactRadial < Pi/2 && 0 < theta < Pi && Element[compactCoordinates, Reals] && If[dimension === 5, 0 < chi < Pi, True];
  boundaryDenominator = Cos[tau] + Last[unitDirection];
  boundaryAssumptions = L > 0 && -Pi < tau < Pi && 0 < theta < Pi && Element[boundaryCoordinates, Reals] && boundaryDenominator > 0 && If[dimension === 5, 0 < chi < Pi, True];
  notebookNames = {"ads" <> ToString[dimension] <> "-poincare", "ads" <> ToString[dimension] <> "-global"};
  coordinateReplacements = {radius -> L, t[] -> tp, x[] -> x, y[] -> y, w[] -> w, z[] -> z, chi[] -> chi, theta[] -> theta, phi[] -> phi};
  notebookPoincareMetric = readNotebookMetric[notebookNames[[1]], coordinateReplacements];
  notebookGlobalMetric = readNotebookMetric[notebookNames[[2]], {radius -> L, t[] -> tg, r[] -> radial, chi[] -> chi, theta[] -> theta, phi[] -> phi}];
  checks = <|
    "UnitSphereConstraint" -> zeroQ[unitDirection . unitDirection - 1, globalAssumptions],
    "UnitSphereMetric" -> zeroQ[pullback[IdentityMatrix[dimension - 1], unitDirection, angles] - sphereMetric, globalAssumptions],
    "PoincareQuadric" -> zeroQ[poincareMap . ambientMetric . poincareMap + L^2, poincareAssumptions],
    "GlobalQuadric" -> zeroQ[globalMap . ambientMetric . globalMap + L^2, globalAssumptions],
    "PoincareAmbientPullback" -> zeroQ[pullback[ambientMetric, poincareMap, poincareCoordinates] - expectedPoincareMetric, poincareAssumptions],
    "GlobalAmbientPullback" -> zeroQ[pullback[ambientMetric, globalMap, globalCoordinates] - expectedGlobalMetric, globalAssumptions],
    "PoincareMetricMatchesNotebook" -> zeroQ[expectedPoincareMetric - notebookPoincareMetric, poincareAssumptions],
    "ArealMetricMatchesNotebook" -> zeroQ[expectedArealMetric - notebookGlobalMetric, arealAssumptions],
    "PoincareInverseAfterEmbedding" -> zeroQ[inversePoincare[poincareMap] - poincareCoordinates, poincareAssumptions]
  |>;
  Print["AdS", dimension, " | embeddings and Notebook metrics | ", ToString[checks, InputForm]];
  requireTrue[And @@ Values[checks], "embedding checks: AdS" <> ToString[dimension]];
  ambientVariables = Array[ambient, dimension + 1];
  ambientQuadric = ambientVariables . ambientMetric . ambientVariables == -L^2;
  ambientAssumptions = L > 0 && Element[ambientVariables, Reals] && ambientQuadric && First[ambientVariables] + Last[ambientVariables] > 0;
  reconstructedAmbient = poincareEmbedding[inversePoincare[ambientVariables]];
  inverseGlobal = FullSimplify[inversePoincare[globalMap], globalAssumptions];
  commonPullback = pullback[expectedPoincareMetric /. Thread[poincareCoordinates -> inverseGlobal], inverseGlobal, globalCoordinates];
  AssociateTo[checks, {
    "PoincareEmbeddingAfterInverseOnQuadric" -> zeroQ[reconstructedAmbient - ambientVariables, ambientAssumptions],
    "CommonDomainDenominator" -> zeroQ[First[globalMap] + Last[globalMap] - globalDenominator, globalAssumptions],
    "GlobalInverseZFormula" -> zeroQ[Last[inverseGlobal] - L^2/globalDenominator, globalAssumptions],
    "InverseZPositiveForPositiveAmbientSum" -> TrueQ[Resolve[ForAll[{positiveLength, positiveAmbientSum}, Implies[positiveLength > 0 && positiveAmbientSum > 0, positiveLength^2/positiveAmbientSum > 0]], Reals]],
    "PoincareEmbeddingAfterGlobalInverse" -> zeroQ[poincareEmbedding[inverseGlobal] - globalMap, commonAssumptions],
    "DirectCommonDomainMetricPullback" -> zeroQ[commonPullback - expectedGlobalMetric, commonAssumptions]
  }];
  Print["AdS", dimension, " | inverse and common-domain | ", ToString[checks, InputForm]];
  requireTrue[And @@ Values[checks], "inverse/common-domain checks: AdS" <> ToString[dimension]];
  arealToGlobal = Join[{tg/L, ArcSinh[radial/L]}, angles];
  compactToGlobal = Join[{tau, ArcSinh[Tan[compactRadial]]}, angles];
  compactMetric = pullback[expectedGlobalMetric /. Thread[globalCoordinates -> compactToGlobal], compactToGlobal, compactCoordinates];
  expectedCompactMetric = L^2/Cos[compactRadial]^2 DiagonalMatrix[Join[{-1, 1}, Sin[compactRadial]^2 Diagonal[sphereMetric]]];
  boundaryIndices = Join[{1}, Range[3, dimension]];
  globalBoundaryMetric = Limit[(Cos[compactRadial]^2/L^2 expectedCompactMetric)[[boundaryIndices, boundaryIndices]], compactRadial -> Pi/2, Direction -> "FromBelow"];
  poincareBoundaryMetric = Limit[(z^2/L^2 expectedPoincareMetric)[[Range[dimension - 1], Range[dimension - 1]]], z -> 0, Direction -> "FromAbove"];
  cylinderMetric = DiagonalMatrix[Join[{-1}, Diagonal[sphereMetric]]];
  boundaryPoincareMap = Limit[(inverseGlobal /. rho -> ArcSinh[Tan[compactRadial]])[[Range[dimension - 1]]], compactRadial -> Pi/2, Direction -> "FromBelow", Assumptions -> boundaryAssumptions];
  expectedBoundaryMap = L Join[{Sin[tau]}, Most[unitDirection]]/boundaryDenominator;
  boundaryPullback = pullback[poincareBoundaryMetric, expectedBoundaryMap, boundaryCoordinates];
  AssociateTo[checks, {
    "ArealHyperbolicMetricTransformation" -> zeroQ[pullback[expectedGlobalMetric /. Thread[globalCoordinates -> arealToGlobal], arealToGlobal, arealCoordinates] - notebookGlobalMetric, arealAssumptions],
    "ArealRadiusInverse" -> zeroQ[L Sinh[ArcSinh[radial/L]] - radial, arealAssumptions],
    "HyperbolicRadiusInverse" -> zeroQ[ArcSinh[Sinh[rho]] - rho, globalAssumptions],
    "CompactRadialMetricTransformation" -> zeroQ[compactMetric - expectedCompactMetric, compactAssumptions],
    "PoincareBoundaryRepresentative" -> zeroQ[poincareBoundaryMetric - DiagonalMatrix[Join[{-1}, ConstantArray[1, dimension - 2]]], poincareAssumptions],
    "GlobalBoundaryRepresentative" -> zeroQ[globalBoundaryMetric - cylinderMetric, boundaryAssumptions],
    "CommonBoundaryCoordinateLimit" -> zeroQ[boundaryPoincareMap - expectedBoundaryMap, boundaryAssumptions],
    "CommonBoundaryConformalMetric" -> zeroQ[boundaryPullback - L^2/boundaryDenominator^2 cylinderMetric, boundaryAssumptions]
  }];
  requireTrue[Length[checks] === 23, "23 coordinate checks recorded: AdS" <> ToString[dimension]];
  requireTrue[And @@ Values[checks], "areal/boundary checks: AdS" <> ToString[dimension]];
  notebookHashes = Table[<|"case" -> notebookName, "sha256" -> FileHash[FileNameJoin[{examplesDirectory, notebookName, notebookName <> ".nb"}], "SHA256", "HexString"]|>, {notebookName, notebookNames}];
  Print["AdS", dimension, " | ", ToString[checks, InputForm]];
  <|"dimension" -> dimension, "checks" -> checks, "notebooks" -> notebookHashes, "commonDomain" -> ToString[commonAssumptions, InputForm], "globalToPoincare" -> ToString[inverseGlobal, InputForm], "boundaryCoordinates" -> ToString[boundaryCoordinates, InputForm], "boundaryMapToMinkowski" -> ToString[expectedBoundaryMap, InputForm], "boundaryConformalFactor" -> ToString[L^2/boundaryDenominator^2, InputForm], "globalBoundaryRepresentative" -> ToString[cylinderMetric, InputForm], "poincareBoundaryRepresentative" -> ToString[poincareBoundaryMetric, InputForm]|>
];
dimensionResults = Table[Check[reviewDimension[reviewDimensionValue], Print["FAILED | symbolic coordinate evaluation message"]; Quit[2]], {reviewDimensionValue, {4, 5}}];
If[!DirectoryQ[outputDirectory], CreateDirectory[outputDirectory]];
exportedPath = Check[Export[FileNameJoin[{outputDirectory, "ads-coordinate-review.json"}], <|"generatedAtUTC" -> DateString[TimeZoneConvert[Now, 0], "ISODateTime"], "wolframVersion" -> System`$Version, "programSHA256" -> FileHash[$InputFileName, "SHA256", "HexString"], "allCoordinateChecksPassed" -> True, "scope" -> "Exact local embedding, inverse, metric pullback and conformal-boundary checks on one chosen time lift; no claim of global topology or GUI verification.", "reference" -> "https://arxiv.org/abs/hep-th/9905111", "referenceSection" -> "2.2.1, equations (2.20)-(2.27)", "cases" -> dimensionResults|>, "RawJSON"], Print["FAILED | AdS review export"]; Quit[2]];
requireTrue[FileExistsQ[exportedPath], "AdS review export"];
Print["ADS_COORDINATE_REVIEW_PASSED | dimensions=4,5 | output=outputs/ads-coordinate-review.json"];
Quit[0];
