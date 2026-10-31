(* 独立核验程序。主要教学计算位于各案例 Notebook；本程序不加载 xAct。 *)
$HistoryLength = 0;
guideDirectory = DirectoryName[DirectoryName[$InputFileName]];
examplesDirectory = FileNameJoin[{guideDirectory, "examples"}];
outputDirectory = FileNameJoin[{guideDirectory, "outputs"}];
Print["INDEPENDENT_REVIEW_START | ", System`$Version];
requireTrue[value_, label_] := If[!TrueQ[value], Print["FAILED | ", label]; Quit[1]];
zeroQ[expression_, assumptions_] := AllTrue[Flatten[{Simplify[expression, assumptions]}], TrueQ[# === 0] &];

(* 所有输入 metric 均为 diagonal；Kretschmann 的直接 contraction 使用这个前提。 *)
coordinateCurvature[coordinates_List, metric_?MatrixQ, assumptions_] := Module[
  {dimension, inverse, connection, carroll, ricci, scalar, lowered, reviewI, reviewJ, reviewK, reviewL, reviewH},
  dimension = Length[coordinates];
  requireTrue[Dimensions[metric] === {dimension, dimension}, "metric dimensions"];
  requireTrue[zeroQ[metric - DiagonalMatrix[Diagonal[metric]], assumptions], "diagonal metric required"];
  inverse = Simplify[Inverse[metric], assumptions];
  connection = Table[Simplify[Total[Table[inverse[[reviewI, reviewH]] (D[metric[[reviewH, reviewK]], coordinates[[reviewJ]]] + D[metric[[reviewH, reviewJ]], coordinates[[reviewK]]] - D[metric[[reviewJ, reviewK]], coordinates[[reviewH]]]), {reviewH, dimension}]]/2, assumptions], {reviewI, dimension}, {reviewJ, dimension}, {reviewK, dimension}];
  carroll = Table[Simplify[D[connection[[reviewI, reviewL, reviewJ]], coordinates[[reviewK]]] - D[connection[[reviewI, reviewK, reviewJ]], coordinates[[reviewL]]] + Total[Table[connection[[reviewI, reviewK, reviewH]] connection[[reviewH, reviewL, reviewJ]] - connection[[reviewI, reviewL, reviewH]] connection[[reviewH, reviewK, reviewJ]], {reviewH, dimension}]], assumptions], {reviewI, dimension}, {reviewJ, dimension}, {reviewK, dimension}, {reviewL, dimension}];
  ricci = Table[Simplify[Total[Table[carroll[[reviewI, reviewJ, reviewI, reviewL]], {reviewI, dimension}]], assumptions], {reviewJ, dimension}, {reviewL, dimension}];
  scalar = Simplify[Total[Flatten[inverse ricci]], assumptions];
  lowered = Table[Simplify[Total[Table[metric[[reviewI, reviewH]] carroll[[reviewH, reviewJ, reviewK, reviewL]], {reviewH, dimension}]], assumptions], {reviewI, dimension}, {reviewJ, dimension}, {reviewK, dimension}, {reviewL, dimension}];
  <|"metric" -> metric, "inverse" -> inverse, "connection" -> connection, "carroll" -> carroll, "riemann" -> lowered, "ricci" -> ricci, "scalar" -> scalar, "einstein" -> Simplify[ricci - metric scalar/2, assumptions]|>
];
diagonalKretschmann[data_, assumptions_] := Module[{dimension, reviewI, reviewJ, reviewK, reviewL},
  dimension = Length[data["metric"]];
  Simplify[Total[Flatten[Table[data["inverse"][[reviewI, reviewI]] data["inverse"][[reviewJ, reviewJ]] data["inverse"][[reviewK, reviewK]] data["inverse"][[reviewL, reviewL]] data["riemann"][[reviewI, reviewJ, reviewK, reviewL]]^2, {reviewI, dimension}, {reviewJ, dimension}, {reviewK, dimension}, {reviewL, dimension}]]], assumptions]
];
coordinateRules = {t[] -> t, r[] -> r, theta[] -> theta, phi[] -> phi, chi[] -> chi, x[] -> x, y[] -> y, z[] -> z, w[] -> w};
readResult[caseName_] := Module[{path, data},
  path = FileNameJoin[{examplesDirectory, caseName, "outputs", "results.json"}];
  requireTrue[FileExistsQ[path], "missing result: " <> caseName];
  data = Import[path, "RawJSON"];
  requireTrue[data["case"] === caseName && And @@ Values[data["checks"]], "source result checks: " <> caseName];
  data
];
parseResult[data_, key_] := ToExpression[data[key], InputForm] /. coordinateRules;
caseChecks = <||>;
independentValues = <||>;
recordChecks[caseName_, checks_Association] := (
  Print[caseName, " | ", ToString[checks, InputForm]];
  requireTrue[And @@ Values[checks], "independent comparison: " <> caseName];
  AssociateTo[caseChecks, caseName -> Join[Lookup[caseChecks, caseName, <||>], checks]];
);
runCoordinate[caseName_, coordinates_, metric_, assumptions_, sectional_] := Module[
  {data, exported, dimension, checks, residual, kretschmann, values, reviewI, reviewJ, reviewK, reviewL},
  data = coordinateCurvature[coordinates, metric, assumptions];
  exported = readResult[caseName];
  dimension = Length[coordinates];
  checks = <|"PublicScalarMatchesIndependent" -> zeroQ[parseResult[exported, "scalar"] - data["scalar"], assumptions]|>;
  values = <|"ricci" -> ToString[data["ricci"], InputForm], "scalar" -> ToString[data["scalar"], InputForm]|>;
  If[KeyExistsQ[exported, "ricci"], AssociateTo[checks, "PublicRicciMatchesIndependent" -> zeroQ[parseResult[exported, "ricci"] - data["ricci"], assumptions]]];
  If[KeyExistsQ[exported, "einstein"], AssociateTo[checks, "PublicEinsteinMatchesIndependent" -> zeroQ[parseResult[exported, "einstein"] - data["einstein"], assumptions]]];
  If[KeyExistsQ[exported, "kretschmann"],
    kretschmann = diagonalKretschmann[data, assumptions];
    AssociateTo[checks, "PublicKretschmannMatchesIndependent" -> zeroQ[parseResult[exported, "kretschmann"] - kretschmann, assumptions]];
    AssociateTo[values, "kretschmann" -> ToString[kretschmann, InputForm]];
  ];
  If[sectional =!= None,
    residual = Table[data["riemann"][[reviewI, reviewJ, reviewK, reviewL]] - sectional (metric[[reviewI, reviewK]] metric[[reviewJ, reviewL]] - metric[[reviewI, reviewL]] metric[[reviewJ, reviewK]]), {reviewI, dimension}, {reviewJ, dimension}, {reviewK, dimension}, {reviewL, dimension}];
    AssociateTo[checks, "FullConstantCurvature" -> zeroQ[residual, assumptions]];
  ];
  recordChecks[caseName, checks];
  AssociateTo[independentValues, caseName -> values];
  data
];

(* 按 Notebook 实际采用的 chart 计算全部九个坐标案例。 *)
flat = runCoordinate["flat-polar", {r, phi}, DiagonalMatrix[{1, r^2}], r > 0, 0];
recordChecks["flat-polar", <|"PublicConnectionMatchesIndependent" -> zeroQ[parseResult[readResult["flat-polar"], "connection"] - flat["connection"], r > 0]|>];
sphere = runCoordinate["two-sphere", {theta, phi}, DiagonalMatrix[{radius^2, radius^2 Sin[theta]^2}], radius > 0 && 0 < theta < Pi, 1/radius^2];
recordChecks["two-sphere", <|"MixedRiemannConventionSample" -> TrueQ[parseResult[readResult["two-sphere"], "riemannSample"] === -sphere["carroll"][[2, 1, 1, 2]]]|>];
runCoordinate["ads4-poincare", {t, x, y, z}, radius^2/z^2 DiagonalMatrix[{-1, 1, 1, 1}], radius > 0 && z > 0, -1/radius^2];
runCoordinate["ads5-poincare", {t, x, y, w, z}, radius^2/z^2 DiagonalMatrix[{-1, 1, 1, 1, 1}], radius > 0 && z > 0, -1/radius^2];
runCoordinate["ads4-global", {t, r, theta, phi}, DiagonalMatrix[{-(1 + r^2/radius^2), 1/(1 + r^2/radius^2), r^2, r^2 Sin[theta]^2}], radius > 0 && r > 0 && 0 < theta < Pi, -1/radius^2];
runCoordinate["ads5-global", {t, r, chi, theta, phi}, DiagonalMatrix[{-(1 + r^2/radius^2), 1/(1 + r^2/radius^2), r^2, r^2 Sin[chi]^2, r^2 Sin[chi]^2 Sin[theta]^2}], radius > 0 && r > 0 && 0 < chi < Pi && 0 < theta < Pi, -1/radius^2];
runCoordinate["ds4", {t, r, theta, phi}, DiagonalMatrix[{-(1 - r^2/radius^2), 1/(1 - r^2/radius^2), r^2, r^2 Sin[theta]^2}], radius > 0 && 0 < r < radius && 0 < theta < Pi, 1/radius^2];
schwarzschildAssumptions = mass > 0 && r > 2 mass && 0 < theta < Pi;
schwarzschild = runCoordinate["schwarzschild", {t, r, theta, phi}, DiagonalMatrix[{-(1 - 2 mass/r), 1/(1 - 2 mass/r), r^2, r^2 Sin[theta]^2}], schwarzschildAssumptions, None];
coordinates = {t, r, theta, phi};
paths = {time[s], radial[s], polar[s], azimuth[s]};
pathVelocity = D[paths, s];
independentGeodesic = Table[D[paths[[reviewI]], {s, 2}] + Total[Flatten[Table[(schwarzschild["connection"][[reviewI, reviewJ, reviewK]] /. Thread[coordinates -> paths]) pathVelocity[[reviewJ]] pathVelocity[[reviewK]], {reviewJ, 4}, {reviewK, 4}]]], {reviewI, 4}];
schwarzschildResult = readResult["schwarzschild"];
equatorial = independentGeodesic /. {polar[s] -> Pi/2, polar'[s] -> 0, polar''[s] -> 0};
energyDerivativeResidual = Simplify[D[(1 - 2 mass/radial[s]) time'[s], s] - (1 - 2 mass/radial[s]) equatorial[[1]]];
angularDerivativeResidual = Simplify[D[radial[s]^2 azimuth'[s], s] - radial[s]^2 equatorial[[4]]];
independentConstraint = Simplify[(1 - 2 mass/radial[s]) (-(1 - 2 mass/radial[s]) time'[s]^2 + radial'[s]^2/(1 - 2 mass/radial[s]) + radial[s]^2 azimuth'[s]^2 + normalizationParameter) /. {time'[s] -> energy/(1 - 2 mass/radial[s]), azimuth'[s] -> angularMomentum/radial[s]^2}];
independentRadial = Simplify[equatorial[[2]] /. {time'[s] -> energy/(1 - 2 mass/radial[s]), azimuth'[s] -> angularMomentum/radial[s]^2} /. radial'[s]^2 -> energy^2 - (1 - 2 mass/radial[s]) (normalizationParameter + angularMomentum^2/radial[s]^2)];
recordChecks["schwarzschild", <|"AllFourPublicGeodesics" -> zeroQ[parseResult[schwarzschildResult, "geodesic"] - independentGeodesic, True], "EnergyConservation" -> zeroQ[energyDerivativeResidual, True], "AngularMomentumConservation" -> zeroQ[angularDerivativeResidual, True], "PublicRadialConstraint" -> zeroQ[parseResult[schwarzschildResult, "radialConstraint"] - independentConstraint, True], "PublicRadialEquation" -> zeroQ[parseResult[schwarzschildResult, "radialEquation"] - independentRadial, True]|>];

flrwAssumptions = aScale[t] > 0 && r > 0 && 1 - k r^2 > 0 && 0 < theta < Pi && GN > 0 && Element[{k, lambda, t, phi}, Reals];
flrw = runCoordinate["flrw", coordinates, DiagonalMatrix[{-1, aScale[t]^2/(1 - k r^2), aScale[t]^2 r^2, aScale[t]^2 r^2 Sin[theta]^2}], flrwAssumptions, None];
flrwResult = readResult["flrw"];
stress = (rho[t] + pressure[t]) Outer[Times, {-1, 0, 0, 0}, {-1, 0, 0, 0}] + pressure[t] flrw["metric"];
mixedStress = Simplify[flrw["inverse"] . stress, flrwAssumptions];
divergence = Table[Simplify[Total[Table[D[mixedStress[[reviewI, reviewJ]], coordinates[[reviewI]]] + Total[Table[flrw["connection"][[reviewI, reviewI, reviewH]] mixedStress[[reviewH, reviewJ]] - flrw["connection"][[reviewH, reviewI, reviewJ]] mixedStress[[reviewI, reviewH]], {reviewH, 4}]], {reviewI, 4}]], flrwAssumptions], {reviewJ, 4}];
geometricDensity = (flrw["einstein"][[1, 1]] - lambda)/(8 Pi GN);
geometricPressure = (flrw["einstein"][[2, 2]]/flrw["metric"][[2, 2]] + lambda)/(8 Pi GN);
continuityFromGeometry = Simplify[D[geometricDensity, t] + 3 aScale'[t] (geometricDensity + geometricPressure)/aScale[t], flrwAssumptions];
fieldResidual = Simplify[flrw["einstein"] + lambda flrw["metric"] - 8 Pi GN stress, flrwAssumptions];
recordChecks["flrw", <|"PublicDensityResidual" -> zeroQ[parseResult[flrwResult, "densityResidual"] - fieldResidual[[1, 1]], flrwAssumptions], "PublicPressureResidual" -> zeroQ[parseResult[flrwResult, "pressureResidual"] - fieldResidual[[2, 2]]/flrw["metric"][[2, 2]], flrwAssumptions], "DirectMixedStressDivergence" -> zeroQ[divergence - {-(rho'[t] + 3 aScale'[t] (rho[t] + pressure[t])/aScale[t]), 0, 0, 0}, flrwAssumptions], "ContinuityFromComputedGeometry" -> zeroQ[continuityFromGeometry, flrwAssumptions], "PublicContinuityResidual" -> zeroQ[parseResult[flrwResult, "continuityResidual"] - continuityFromGeometry, flrwAssumptions]|>];
AssociateTo[independentValues, "flrw" -> Join[independentValues["flrw"], <|"mixedStressDivergence" -> ToString[divergence, InputForm], "continuityFromComputedGeometry" -> ToString[continuityFromGeometry, InputForm]|>]];

(* 其余四个案例比较公开表达式与独立解析恒等式；方法及推导见 independent-review.md。 *)
tensorResult = readResult["tensor-algebra"];
recordChecks["tensor-algebra", <|"PublicAlgebraIdentities" -> TrueQ[parseResult[tensorResult, "results"] === {0, 4, velocity[a], 0}]|>];
derivativeResult = readResult["covariant-derivatives"];
vectorCommutator = parseResult[derivativeResult, "vectorCommutator"];
covectorCommutator = parseResult[derivativeResult, "covectorCommutator"];
vectorDummy = Cases[vectorCommutator, vector[index_Symbol] :> index, Infinity];
covectorDummy = Cases[covectorCommutator, omega[index_Symbol] :> index, Infinity];
requireTrue[Length[vectorDummy] === 1 && Length[covectorDummy] === 1, "one dummy index per commutator"];
recordChecks["covariant-derivatives", <|"PublicVectorConvention" -> TrueQ[vectorCommutator === RiemannCD[-a, -b, c, -First[vectorDummy]] vector[First[vectorDummy]]], "PublicCovectorConvention" -> TrueQ[covectorCommutator === RiemannCD[-a, -b, -c, -First[covectorDummy]] omega[First[covectorDummy]]]|>];
lieResult = readResult["lie-derivatives-killing"];
recordChecks["lie-derivatives-killing", <|"PublicMetricLieDerivative" -> TrueQ[parseResult[lieResult, "lieMetric"] === CD[-b][flow[-c]] + CD[-c][flow[-b]]], "PublicRotationKilling" -> TrueQ[parseResult[lieResult, "rotationLie"] === ConstantArray[0, {2, 2}]]|>];
maximalResult = readResult["maximally-symmetric"];
recordChecks["maximally-symmetric", <|"GeneralDimensionRicci" -> zeroQ[parseResult[maximalResult, "ricci"] - (dimension - 1) curvature g[-b, -d], True], "GeneralDimensionScalar" -> zeroQ[parseResult[maximalResult, "scalar"] - dimension (dimension - 1) curvature, True], "GeneralDimensionKretschmann" -> zeroQ[parseResult[maximalResult, "kretschmann"] - 2 dimension (dimension - 1) curvature^2, True], "GeneralDimensionLambda" -> zeroQ[parseResult[maximalResult, "lambda"] - (dimension - 1) (dimension - 2) curvature/2, True]|>];

(* 被人工审读的 Input 表达式摘要；保存、排版和输出分组可改变 Notebook 文件摘要。 *)
reviewedInputHashes = <|
  "tensor-algebra" -> "65f3301f0e14fd2b0ca3296b75d6f74b0971a449fb1e0bc019b1aa184dd548dc",
  "covariant-derivatives" -> "03d3d34dd810e8bdc627fbaa7095892b9bfe691646b01804ff3fb4d9362be1da",
  "lie-derivatives-killing" -> "540d3d347563af4aefb0fd0f5eb2be851337834f3e550a82200434c94088f14b",
  "flat-polar" -> "2dc672c2b69cc56aac851ad1fdaec6fc99e9f3a2a5951f98a8c1a9a09963e545",
  "two-sphere" -> "04f3ddd1a134bb30d5f195bfc821bd06919b316b1b5eeb3582578082bb986f27",
  "schwarzschild" -> "ad49bf76c0e08f839ee5728ff1827fa216d64ee2e5b3b4c3e68f22eb29945fc5",
  "flrw" -> "0a8e71749b1f4e156eea0d01418d19522375d50498cdf08c70d7f442bf080f8a",
  "maximally-symmetric" -> "173bf90a173805e6d1e5ab74a6935e6a9cbfd4949f7970dd8f3cd3d26500b111",
  "ads4-poincare" -> "4b196b90376a37658b1bad5f9c6cc48dd5436cc2fbb6a0cdf54d55a5393b9e60",
  "ads4-global" -> "212d4d100491a6463bfaf158d1bf9bafec6d13c3fd589b91e8acfb958b8f934c",
  "ads5-poincare" -> "c67934e5443e5e173258fe106ce017467d29efc90f1cf33989ab4ebb8dbac871",
  "ads5-global" -> "a07414bc628f96b3baf390181279268a5108b43d35d55f1601e9ec9860df4791",
  "ds4" -> "47d12b8643ccbbfb3d455f5ab8dedb889bf9efa94d9676e7a78c226210fdb5e3"
|>;
reviewManifest = Table[
  notebookPath = FileNameJoin[{examplesDirectory, caseName, caseName <> ".nb"}];
  notebookExpression = Get[notebookPath];
  inputBoxes = Cases[notebookExpression, Cell[BoxData[boxes_], "Input", ___] :> boxes, Infinity];
  heldInputs = Table[ToExpression[If[ListQ[boxes], RowBox[boxes], boxes], If[StringQ[boxes], InputForm, StandardForm], HoldComplete], {boxes, inputBoxes}];
  inputHash = Hash[heldInputs, "SHA256", "HexString"];
  requireTrue[inputHash === reviewedInputHashes[caseName], "reviewed Input expressions changed: " <> caseName];
  <|"case" -> caseName, "notebook" -> "examples/" <> caseName <> "/" <> caseName <> ".nb", "inputNotebookSHA256" -> FileHash[notebookPath, "SHA256", "HexString"], "inputExpressionSHA256" -> inputHash, "inputExpressionsMatchReviewedVersion" -> True, "sourceResultsSHA256" -> FileHash[FileNameJoin[{examplesDirectory, caseName, "outputs", "results.json"}], "SHA256", "HexString"], "checks" -> caseChecks[caseName], "independentValues" -> Lookup[independentValues, caseName, <||>]|>,
  {caseName, Keys[reviewedInputHashes]}
];
requireTrue[Length[reviewManifest] === 13, "13 reviewed cases"];
If[!DirectoryQ[outputDirectory], CreateDirectory[outputDirectory]];
exportedPath = Check[Export[FileNameJoin[{outputDirectory, "independent-review.json"}], <|"generatedAtUTC" -> DateString[TimeZoneConvert[Now, 0], "ISODateTime"], "wolframVersion" -> System`$Version, "method" -> "Independent coordinate differentiation for nine diagonal metrics; analytic expression comparisons for four abstract cases; no xAct loaded.", "programSHA256" -> FileHash[$InputFileName, "SHA256", "HexString"], "allMathematicalChecksPassed" -> True, "guiReviewedByThisProgram" -> False, "cases" -> reviewManifest|>, "RawJSON"], Print["FAILED | independent result export"]; Quit[2]];
requireTrue[FileExistsQ[exportedPath], "independent result export"];
Print["INDEPENDENT_REVIEW_PASSED | cases=13 | output=outputs/independent-review.json"];
Quit[0];
