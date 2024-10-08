within EHPTlib.MapBased;

package Partial
  partial model PartialOneFlange "Partial map-based one-Flange electric drive model"
    Boolean limitingTorque;
    parameter Modelica.Units.SI.MomentOfInertia J = 0.25 "Rotor's moment of inertia" annotation(
      Dialog(group = "General parameters"));
    parameter Modelica.Units.SI.Voltage uDcNom = 100 "Nominal DC voltage" annotation(
      Dialog(group = "General parameters"));
    parameter Modelica.Units.SI.AngularVelocity wMax = 3000 "Maximum speed (for efficiency and torque limitation when limitsOnFile=false and to normalise input when normalisedInLimits=true)" annotation(
      Dialog(group = "General parameters"));
    parameter Modelica.Units.SI.Power powMax = 22000 "Maximum mechanical power (used for efficiency and torque limitation when limitsOnFile=false)" annotation(
      Dialog(group = "General parameters"));
    //Parameters related to torque limits:
    parameter Boolean limitsOnFile = false "= true, if torque limits are taken from a txt file, otherwise limits are tauMax and wMax" annotation(
      choices(checkBox = true),
      Dialog(group = "Torque limitation related parameters"));
    parameter Boolean normalisedInLimits = false "when true and torques and speeds are read from file, they are normalised (will be multiplied by wMax and tauMax)" annotation(
      choices(checkBox = true),
      Dialog(group = "General parameters", enable = limitsOnFile or effMapOnFile));
    parameter Modelica.Units.SI.Torque tauMax = 80 "Maximum torque when limits are not from an un-normalised file" annotation(
      Dialog(group = "Torque limitation related parameters"));
    parameter String limitsFileName = "noName" "File where efficiency table matrix is stored" annotation(
      Dialog(group = "Torque limitation related parameters", enable = limitsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String maxTorqueTableName = "noName" "Name of the on-file upper torque limit" annotation(
      Dialog(enable = limitsOnFile, group = "Torque limitation related parameters"));
    parameter String minTorqueTableName = "noName" "Name of the on-file lower torque limit" annotation(
      Dialog(enable = limitsOnFile, group = "Torque limitation related parameters"));
    //Parameters related to efficiency combi table:
    parameter Boolean efficiencyFromTable = true "=true if efficiency if from a table (either online or from a file); otherwise use a the built-in loss formula" annotation(
      choices(checkBox = true),
      Dialog(group = "Efficiency related parameters"));
    parameter Boolean effMapOnFile = false "= true, if tables are taken from a txt file" annotation(
      choices(checkBox = true),
      Dialog(enable = efficiencyFromTable, group = "Efficiency related parameters"));
    parameter String effMapFileName = "noName" "File where efficiency table matrix is stored" annotation(
      Dialog(group = "Efficiency related parameters", enable = effMapOnFile and efficiencyFromTable, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String effTableName = "noName" "Name of the on-file efficiency matrix" annotation(
      Dialog(enable = effMapOnFile and efficiencyFromTable, group = "Efficiency related parameters"));
    parameter Real effTable[:, :] = [0, 0, 1; 0, 1, 1; 1, 1, 1] "rows: speeds; columns: torques; both PU of wMax and tauMax" annotation(
      Dialog(enable = not effMapOnFile and efficiencyFromTable, group = "Efficiency related parameters"));
    //Parameters related to the loss-formula:
    parameter Real A = 0.006 "fixed losses" annotation(
      Dialog(enable = not efficiencyFromTable, group = "Loss-formula parameters"));
    parameter Real bT = 0.05 "torque losses coefficient" annotation(
      Dialog(enable = not efficiencyFromTable, group = "Loss-formula parameters"));
    parameter Real bW = 0.02 "speed losses coefficient" annotation(
      Dialog(enable = not efficiencyFromTable, group = "Loss-formula parameters"));
    parameter Real bP = 0.05 "power losses coefficient" annotation(
      Dialog(enable = not efficiencyFromTable, group = "Loss-formula parameters"));
    final parameter Modelica.Units.SI.Torque nomTorque(fixed = false);
    //actual Max torque value for consumption map (which in file is between 0 and 1)
    final parameter Real nomSpeedEff(fixed = false);
    //Similar to nomSpeed, but with rad/s to rpm conversion when needed for Efficiency table
    final parameter Modelica.Units.SI.AngularVelocity nomSpeed(fixed = false);
    //actual Max speed value for consumption map (which in file is between 0 and 1)
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation(
      Placement(transformation(extent = {{88, 50}, {108, 70}}, rotation = 0), iconTransformation(extent = {{90, -10}, {110, 10}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor wSensor annotation(
      Placement(transformation(extent = {{8, -8}, {-8, 8}}, rotation = 90, origin = {84, 44})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(extent = {{-110, 30}, {-90, 50}}), iconTransformation(extent = {{-110, 30}, {-90, 50}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(extent = {{-110, -50}, {-90, -30}}), iconTransformation(extent = {{-110, -50}, {-90, -30}})));
    SupportModels.MapBasedRelated.ConstPg pDC(vNom = uDcNom) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-88, 0})));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = J) annotation(
      Placement(transformation(extent = {{48, 50}, {68, 70}})));
    Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
      Placement(transformation(extent = {{-16, 50}, {4, 70}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powSensor annotation(
      Placement(transformation(extent = {{18, 50}, {38, 70}})));
    Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
      Placement(transformation(extent = {{-28, 20}, {-48, 40}})));
    SupportModels.MapBasedRelated.LimTorque limTau(normalisedInput = normalisedInLimits, limitsOnFile = limitsOnFile, tauMax = tauMax, wMax = wMax, powMax = powMax, limitsFileName = limitsFileName, maxTorqueTableName = maxTorqueTableName, minTorqueTableName = minTorqueTableName) annotation(
      Placement(transformation(extent = {{50, -2}, {30, 22}})));
    SupportModels.Miscellaneous.Gain fromPuTorque(k = nomTorque) annotation(
      Placement(visible = true, transformation(origin = {14, 30}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
    SupportModels.Miscellaneous.Gain fromPuTorque1(k = nomTorque) annotation(
      Placement(visible = true, transformation(origin = {14, 2}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
    SupportModels.Miscellaneous.Gain toPuSpeed(k = 1/nomSpeed) annotation(
      Placement(visible = true, transformation(origin = {68, 10}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
    SupportModels.MapBasedRelated.EfficiencyCT toElePow(mapsOnFile = effMapOnFile, tauMax = nomTorque, wMax = nomSpeedEff, mapsFileName = effMapFileName, effTableName = effTableName, effTable = effTable) if efficiencyFromTable annotation(
      Placement(transformation(extent = {{-38, -34}, {-58, -14}})));
    SupportModels.MapBasedRelated.EfficiencyLF toElePow1(A = A, bT = bT, bW = bW, bP = bP, tauMax = tauMax, powMax = powMax, wMax = wMax) if not efficiencyFromTable annotation(
      Placement(transformation(extent = {{-38, -56}, {-58, -36}})));
  initial equation
    if limitsOnFile and normalisedInLimits then
      nomTorque = tauMax;
      nomSpeed = wMax;
      nomSpeedEff = wMax;
    else
      nomTorque = 1;
      nomSpeed = 1;
      /* EfficiencyCT internally divides inputs by nomTorque and nomSpeed, to use normalised maps.
         In case maps are un-normalised, torque must be divided by one. 
         As regards speed, the dividing quotient depends on the unit of measure in which speeds are written 
         on txt file. In EHPTlib it has been decided, for user's convenience, to input speeds in rpm, so 
         in case of un-normalised maps we must consider the corresponding conversion factor */
      nomSpeedEff = (2*Modelica.Constants.pi)/60;   
    end if;
  equation
  if abs(variableLimiter.y-variableLimiter.u)> 1e-15 then
      limitingTorque=true;
    else
      limitingTorque=false;
    end if;
  
    connect(pin_p, pDC.pin_p) annotation(
      Line(points = {{-100, 40}, {-100, 24}, {-88, 24}, {-88, 10}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(pin_n, pDC.pin_n) annotation(
      Line(points = {{-100, -40}, {-100, -24}, {-88, -24}, {-88, -9.8}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(wSensor.flange, flange_a) annotation(
      Line(points = {{84, 52}, {84, 60}, {98, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(variableLimiter.y, torque.tau) annotation(
      Line(points = {{-49, 30}, {-60, 30}, {-60, 60}, {-18, 60}}, color = {0, 0, 127}));
    connect(torque.flange, powSensor.flange_a) annotation(
      Line(points = {{4, 60}, {18, 60}}, color = {0, 0, 0}));
    connect(powSensor.flange_b, inertia.flange_a) annotation(
      Line(points = {{38, 60}, {48, 60}}, color = {0, 0, 0}));
    connect(inertia.flange_b, flange_a) annotation(
      Line(points = {{68, 60}, {98, 60}}, color = {0, 0, 0}));
    connect(fromPuTorque1.u, limTau.yL) annotation(
      Line(points = {{21.2, 2}, {24, 2.8}, {29, 2.8}}, color = {0, 0, 127}));
    connect(fromPuTorque.u, limTau.yH) annotation(
      Line(points = {{21.2, 30}, {26, 30}, {26, 17.2}, {29, 17.2}}, color = {0, 0, 127}));
    connect(variableLimiter.limit1, fromPuTorque.y) annotation(
      Line(points = {{-26, 38}, {2, 38}, {2, 30}, {7.4, 30}}, color = {0, 0, 127}));
    connect(variableLimiter.limit2, fromPuTorque1.y) annotation(
      Line(points = {{-26, 22}, {-4, 22}, {-4, 2}, {7.4, 2}}, color = {0, 0, 127}));
    connect(limTau.w, toPuSpeed.y) annotation(
      Line(points = {{52, 10}, {59.2, 10}}, color = {0, 0, 127}));
    connect(toPuSpeed.u, wSensor.w) annotation(
      Line(points = {{77.6, 10}, {84, 10}, {84, 35.2}}, color = {0, 0, 127}));
    connect(pDC.Pref, toElePow.elePow) annotation(
      Line(points = {{-79.8, 0}, {-68, 0}, {-68, -24}, {-58.6, -24}}, color = {0, 0, 127}));
    connect(toElePow.tau, variableLimiter.y) annotation(
      Line(points = {{-36, -20}, {-28, -20}, {-28, 0}, {-60, 0}, {-60, 30}, {-49, 30}}, color = {0, 0, 127}));
    connect(toElePow.w, wSensor.w) annotation(
      Line(points = {{-36, -28}, {84, -28}, {84, 35.2}}, color = {0, 0, 127}));
    connect(pDC.Pref, toElePow1.elePow) annotation(
      Line(points = {{-79.8, 0}, {-68, 0}, {-68, -46}, {-58.6, -46}}, color = {0, 0, 127}));
    connect(toElePow1.tau, variableLimiter.y) annotation(
      Line(points = {{-36, -42}, {-28, -42}, {-28, 0}, {-60, 0}, {-60, 30}, {-49, 30}}, color = {0, 0, 127}));
    connect(toElePow1.w, wSensor.w) annotation(
      Line(points = {{-36, -50}, {84, -50}, {84, 35.2}}, color = {0, 0, 127}));
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -60}, {100, 80}}, preserveAspectRatio = false), graphics = {Text(textColor = {238, 46, 47}, extent = {{12, -36}, {54, -40}}, textString = "efficiencyFromTable"), Text(textColor = {238, 46, 47}, extent = {{30, -30}, {72, -46}}, textString = "true

false")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics = {Line(points = {{62, -7}, {82, -7}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{52, 10}, {100, -10}}), Line(points = {{-98, 40}, {-70, 40}}, color = {0, 0, 255}), Line(points = {{-92, -40}, {-70, -40}}, color = {0, 0, 255}), Text(origin = {-17.6473, 11.476}, textColor = {0, 0, 255}, extent = {{-82.3527, 82.524}, {117.641, 50.524}}, textString = "%name"), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, 54}, {80, -54}}), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-74, 26}, {72, -26}}), Text(origin = {-5.9876, 35}, extent = {{-70.0124, -27}, {79.9876, -47}}, textString = "J=%J")}),
      Documentation(info = "<html><head></head><body><p>Partial model for one-flange components.</p>
<p>It contains the large majority of features: inherited components just add the input torque, either from a real input (OneFlange) or an expandable connector (OneFlangeConn).</p>
<p>It has several options:</p>
<p>- torque limits can be fixed values or be taken from a file, depending on <span style=\"font-family: Courier New;\">limitsOnFile</span> parameter. When limits are from a file, the latter can be written in SI units or with normalised torque and speed (will be multiplied by tauMax and wMax)</p>
<p>- efficiency can be defined through a loss formula or a matrix; the latter can, in turn be taken from a file or set online.</p><p><br></p><p>The model does not include the initial speed in the mask, since it is assumed it is set from the outside, e.g. from a connected intertia .</p>
</body></html>", revisions = "<html><head></head><body></body></html>"));
  end PartialOneFlange;

  partial model PartialTwoFlange "Simple map-based two-flange electric drive model"
    parameter Modelica.Units.SI.Power powMax = 50000 "Maximum Mechanical drive power";
    parameter Modelica.Units.SI.Torque tauMax = 400 "Maximum drive Torque";
    parameter Modelica.Units.SI.AngularVelocity wMax = 650 "Maximum drive speed";
    parameter Modelica.Units.SI.MomentOfInertia J = 0.59 "Moment of Inertia";
    parameter Boolean mapsOnFile = false "= true, if tables are taken from a txt file";
    parameter String mapsFileName = "noName" "File where efficiency table is stored" annotation(
      Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String effTableName = "noName" "Name of the on-file maximum torque as a function of speed" annotation(
      Dialog(enable = mapsOnFile));
    parameter Real effTable[:, :] = [0, 0, 1; 0, 1, 1; 1, 1, 1] annotation(
      Dialog(enable = not mapsOnFile));
    SupportModels.MapBasedRelated.LimTorqueFV limTau(tauMax = tauMax, wMax = wMax, powMax = powMax) annotation(
      Placement(transformation(extent = {{-58, -8}, {-36, 14}})));
    SupportModels.MapBasedRelated.InertiaTq inertia(w(displayUnit = "rad/s", start = 0), J = J) annotation(
      Placement(transformation(extent = {{8, 40}, {28, 60}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedRing annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {-80, 40})));
    SupportModels.MapBasedRelated.EfficiencyCT effMap(tauMax = tauMax, wMax = wMax, mapsOnFile = mapsOnFile, mapsFileName = mapsFileName, effTableName = effTableName, effTable = effTable) annotation(
      Placement(transformation(extent = {{20, -46}, {40, -26}})));
    SupportModels.MapBasedRelated.ConstPg constPDC annotation(
      Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = -90, origin = {0, 100})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor outBPow_ annotation(
      Placement(transformation(extent = {{62, 40}, {82, 60}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor outAPow_ annotation(
      Placement(transformation(extent = {{-18, 40}, {-38, 60}})));
    Modelica.Blocks.Math.Add add annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {32, 10})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of shaft" annotation(
      Placement(visible = true, transformation(extent = {{90, 40}, {110, 60}}, rotation = 0), iconTransformation(extent = {{90, -12}, {110, 8}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation(
      Placement(visible = true, transformation(extent = {{-110, 40}, {-90, 60}}, rotation = 0), iconTransformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(visible = true, transformation(extent = {{-70, 90}, {-50, 110}}, rotation = 0), iconTransformation(extent = {{-50, 72}, {-30, 92}}, rotation = 0)));
    Modelica.Blocks.Nonlinear.VariableLimiter torqueLimiter annotation(
      Placement(transformation(extent = {{-16, -8}, {4, 12}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(visible = true, transformation(extent = {{42, 90}, {62, 110}}, rotation = 0), iconTransformation(extent = {{30, 72}, {50, 92}}, rotation = 0)));
  equation
    connect(flange_a, speedRing.flange) annotation(
      Line(points = {{-100, 50}, {-80, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(effMap.w, speedRing.w) annotation(
      Line(points = {{18, -40}, {-80, -40}, {-80, 29}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(pin_p, constPDC.pin_p) annotation(
      Line(points = {{-60, 100}, {-10, 100}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(effMap.elePow, constPDC.Pref) annotation(
      Line(points = {{40.6, -36}, {52, -36}, {52, 80}, {0, 80}, {0, 91.8}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(flange_b, outBPow_.flange_b) annotation(
      Line(points = {{100, 50}, {82, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_b, outBPow_.flange_a) annotation(
      Line(points = {{28, 50}, {62, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_a, outAPow_.flange_a) annotation(
      Line(points = {{8, 50}, {-18, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(outAPow_.flange_b, speedRing.flange) annotation(
      Line(points = {{-38, 50}, {-80, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(add.u1, outBPow_.power) annotation(
      Line(points = {{38, 22}, {38, 28}, {64, 28}, {64, 39}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(add.u2, outAPow_.power) annotation(
      Line(points = {{26, 22}, {26, 28}, {-20, 28}, {-20, 39}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(torqueLimiter.limit1, limTau.yH) annotation(
      Line(points = {{-18, 10}, {-28, 10}, {-28, 9.6}, {-34.9, 9.6}}, color = {0, 0, 127}));
    connect(torqueLimiter.limit2, limTau.yL) annotation(
      Line(points = {{-18, -6}, {-28, -6}, {-28, -3.6}, {-34.9, -3.6}}, color = {0, 0, 127}));
    connect(torqueLimiter.y, inertia.tau) annotation(
      Line(points = {{5, 2}, {12.55, 2}, {12.55, 40}}, color = {0, 0, 127}));
    connect(effMap.tau, torqueLimiter.y) annotation(
      Line(points = {{18, -32}, {12, -32}, {12, 2}, {5, 2}}, color = {0, 0, 127}));
    connect(limTau.w, speedRing.w) annotation(
      Line(points = {{-60.2, 3}, {-80, 3}, {-80, 29}}, color = {0, 0, 127}));
    connect(constPDC.pin_n, pin_n) annotation(
      Line(points = {{9.8, 100}, {18, 100}, {18, 100}, {52, 100}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 100}})),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics = {Text(origin = {4, -112}, textColor = {0, 0, 255}, extent = {{-110, 68}, {100, 36}}, textString = "%name"), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-64, 38}, {64, -42}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 10}, {-64, -10}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{64, 8}, {100, -12}}), Line(origin = {20, 0}, points = {{-60, 86}, {-60, 36}}, color = {0, 0, 255}), Line(origin = {-20, 0}, points = {{60, 80}, {60, 34}}, color = {0, 0, 255}), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-58, 14}, {58, -18}}), Text(origin = {-0.07637, 48.3161}, extent = {{-51.9236, -36.3161}, {48.0764, -66.3161}}, textString = "J=%J")}),
      Documentation(info = "<html>
<p>Partial model for final models TwoFlange and TwoFlangeConn</p>
</html>"));
  end PartialTwoFlange;

  partial model PartialIceBase "Partial map-based ice model"
    import Modelica.Constants.*;
    parameter Modelica.Units.SI.AngularVelocity wIceStart = 167 annotation(
      Dialog(group = "General parameters"));
    parameter Modelica.Units.SI.MomentOfInertia iceJ = 0.5 "ICE moment of Inertia" annotation(
      Dialog(group = "General parameters"));
    parameter Modelica.Units.SI.Torque nomTorque = 1 "Torque multiplier for efficiency map torques" annotation(
      Dialog(enable = mapsOnFile, group = "General parameters"));
    parameter Modelica.Units.SI.AngularVelocity nomSpeed = 1 "Speed multiplier for efficiency map speeds" annotation(
      Dialog(enable = mapsOnFile, group = "General parameters"));
    parameter Boolean mapsOnFile = false "= true, if tables are taken from a txt file" annotation(
      choices(checkBox = true),
      Dialog(group = "Map related parameters"));
    parameter String mapsFileName = "NoName" "File where specific consumption matrix is stored" annotation(
      Dialog(group = "Map related parameters", enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String specConsName = "NoName" "name of the on-file specific consumption variable" annotation(
      Dialog(enable = mapsOnFile, group = "Map related parameters"));
    parameter Real maxIceTau[:, 2](each unit = "N.m") = [100, 80; 200, 85; 300, 92; 350, 98; 400, 98] "Maximum ICE generated torque" annotation(
      Dialog(enable = not mapsOnFile, group = "Map related parameters"));
    parameter Real specificCons[:, :](each unit = "g/(kW.h)") = [0.0, 100, 200, 300, 400, 500; 10, 630, 580, 550, 580, 630; 20, 430, 420, 400, 400, 450; 30, 320, 325, 330, 340, 350; 40, 285, 285, 288, 290, 300; 50, 270, 265, 265, 270, 275; 60, 255, 248, 250, 255, 258; 70, 245, 237, 238, 243, 246; 80, 245, 230, 233, 237, 240; 90, 235, 230, 228, 233, 235] "ICE specific consumption map. First column torque, first row speed" annotation(
      Dialog(enable = not mapsOnFile, group = "Map related parameters"));
    Modelica.Units.SI.Torque tauGenerated = iceTau.tau;
    Modelica.Units.SI.Torque tauMechanical = -flange_a.tau;
    Modelica.Units.SI.AngularVelocity wMechanical = wSensor.w;
    Modelica.Mechanics.Rotational.Components.Inertia inertia(w(fixed = true, start = wIceStart, displayUnit = "rpm"), J = iceJ) annotation(
      Placement(visible = true, transformation(extent = {{30, 68}, {50, 88}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sources.Torque iceTau annotation(
      Placement(visible = true, transformation(extent = {{4, 68}, {24, 88}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor icePow annotation(
      Placement(transformation(extent = {{66, 88}, {86, 68}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor wSensor annotation(
      Placement(visible = true, transformation(origin = {58, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
    Modelica.Blocks.Math.Product toPowW annotation(
      Placement(visible = true, transformation(origin = {-18, 36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation(
      Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
    Modelica.Blocks.Tables.CombiTable2Ds toGramsPerkWh(table = specificCons, tableOnFile = mapsOnFile, tableName = specConsName, fileName = mapsFileName) annotation(
      Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = -90, origin = {44, -2})));
    Modelica.Blocks.Math.Gain tokW(k = 0.001) annotation(
      Placement(visible = true, transformation(origin = {-18, 8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Math.Product toG_perHour annotation(
      Placement(visible = true, transformation(origin = {38, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Continuous.Integrator tokgFuel(k = 1/3.6e6) annotation(
      Placement(visible = true, transformation(origin = {38, -74}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Logical.Switch switch1 annotation(
      Placement(visible = true, transformation(origin = {8, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
      Placement(visible = true, transformation(extent = {{-34, -82}, {-14, -62}}, rotation = 0)));
    Modelica.Blocks.Math.Gain toPuTorque(k = 1/nomTorque) annotation(
      Placement(visible = true, transformation(origin = {25, 29}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
    Modelica.Blocks.Math.Gain toPuSpeed(k = 1/nomSpeed) annotation(
      Placement(visible = true, transformation(origin = {61, 29}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  equation
    connect(toPowW.y, tokW.u) annotation(
      Line(points = {{-18, 25}, {-18, 20}}, color = {0, 0, 127}));
    connect(toPowW.u2, iceTau.tau) annotation(
      Line(points = {{-24, 48}, {-24, 58}, {-6, 58}, {-6, 78}, {2, 78}}, color = {0, 0, 127}));
    connect(iceTau.flange, inertia.flange_a) annotation(
      Line(points = {{24, 78}, {30, 78}}));
    connect(wSensor.flange, inertia.flange_b) annotation(
      Line(points = {{58, 72}, {58, 78}, {50, 78}}));
    connect(icePow.flange_a, inertia.flange_b) annotation(
      Line(points = {{66, 78}, {50, 78}}));
    connect(toPowW.u1, wSensor.w) annotation(
      Line(points = {{-12, 48}, {-12, 51}, {58, 51}}, color = {0, 0, 127}));
    connect(icePow.flange_b, flange_a) annotation(
      Line(points = {{86, 78}, {94, 78}, {94, 0}, {100, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(toGramsPerkWh.y, toG_perHour.u1) annotation(
      Line(points = {{44, -13}, {44, -28}}, color = {0, 0, 127}));
    connect(toG_perHour.y, tokgFuel.u) annotation(
      Line(points = {{38, -51}, {38, -62}}, color = {0, 0, 127}));
    connect(zero.y, switch1.u3) annotation(
      Line(points = {{-13, -72}, {-10, -72}, {-10, -60}, {-4, -60}}, color = {0, 0, 127}));
    connect(toG_perHour.u2, switch1.y) annotation(
      Line(points = {{32, -28}, {32, -20}, {22, -20}, {22, -52}, {19, -52}}, color = {0, 0, 127}));
    connect(switch1.u1, tokW.y) annotation(
      Line(points = {{-4, -44}, {-18, -44}, {-18, -3}}, color = {0, 0, 127}));
    connect(toPuTorque.u, iceTau.tau) annotation(
      Line(points = {{25, 37.4}, {25, 58}, {-6, 58}, {-6, 78}, {2, 78}}, color = {0, 0, 127}));
    connect(wSensor.w, toPuSpeed.u) annotation(
      Line(points = {{58, 51}, {58, 46}, {60, 46}, {60, 37.4}, {61, 37.4}}, color = {0, 0, 127}));
    connect(toPuSpeed.y, toGramsPerkWh.u2) annotation(
      Line(points = {{61, 21.3}, {61, 16}, {50, 16}, {50, 10}}, color = {0, 0, 127}));
    connect(toPuTorque.y, toGramsPerkWh.u1) annotation(
      Line(points = {{25, 21.3}, {25, 16}, {38, 16}, {38, 10}}, color = {0, 0, 127}));
    annotation(
      Documentation(info = "<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basic partial ICE model. Models that inherit from this:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- PartialIceTNm used when ICE must follow a Torque request in Nm</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- PartialIceT01 used when ICE must follow a Torque request in per unit of the maximum allowed</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See their documentation for further details or Appendix 3 in EHPTexamples tutorial for the general taxonomy of ICE based models.</span></p>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 62}, {100, -100}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-24, 48}, {76, -44}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{76, 10}, {100, -10}}), Text(extent = {{-42, -56}, {112, -80}}, textString = "J=%iceJ"), Text(origin = {0, 10}, textColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 48}, {-32, -46}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-90, 2}, {-32, -20}}), Line(points = {{-60, 36}, {-60, 14}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}})}),
      Diagram(coordinateSystem(preserveAspectRatio = false), graphics = {Line(points = {{-20, 78}, {-4, 78}}, color = {238, 46, 47})}));
  end PartialIceBase;

  partial model PartialIceTNm "Partial map-based ice model"
    import Modelica.Constants.*;
    extends PartialIceBase;
    parameter Real contrGain(unit = "N.m/W") = 0.1 "Proportional controller gain" annotation(
      Dialog(group = "General parameters"));
    parameter Modelica.Units.SI.AngularVelocity wIceStart = 167;
    parameter String mapsFileName = "NoName" "File where specific consumption matrix is stored" annotation(
      Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String specConsName = "NoName" "name of the on-file specific consumption variable" annotation(
      Dialog(enable = mapsOnFile));
    Modelica.Blocks.Tables.CombiTable1Dv toLimTau(table = maxIceTau, tableOnFile = mapsOnFile, tableName = "maxIceTau", fileName = mapsFileName) annotation(
      Placement(visible = true, transformation(origin = {-60, 44}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
    Modelica.Blocks.Sources.RealExpression rotorW(y = wSensor.w) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-76, -8})));
    Modelica.Blocks.Math.Min min1 annotation(
      Placement(transformation(extent = {{-34, 68}, {-14, 88}})));
    SupportModels.Miscellaneous.Gain toPuSpeed1(k = 1/nomSpeed) annotation(
      Placement(visible = true, transformation(origin = {-76, 20}, extent = {{6, -6}, {-6, 6}}, rotation = -90)));
    SupportModels.Miscellaneous.Gain fromPuTorque(k = nomTorque) annotation(
      Placement(visible = true, transformation(origin = {-48, 72}, extent = {{6, -6}, {-6, 6}}, rotation = 180)));
  equation
    connect(min1.y, iceTau.tau) annotation(
      Line(points = {{-13, 78}, {2, 78}}, color = {0, 0, 127}));
    connect(toPuSpeed1.y, toLimTau.u[1]) annotation(
      Line(points = {{-76, 26.6}, {-76, 44}, {-72, 44}}, color = {0, 0, 127}));
    connect(toPuSpeed1.u, rotorW.y) annotation(
      Line(points = {{-76, 12.8}, {-76, 3}}, color = {0, 0, 127}));
    connect(fromPuTorque.y, min1.u2) annotation(
      Line(points = {{-41.4, 72}, {-36, 72}}, color = {0, 0, 127}));
    connect(fromPuTorque.u, toLimTau.y[1]) annotation(
      Line(points = {{-55.2, 72}, {-68, 72}, {-68, 58}, {-40, 58}, {-40, 44}, {-49, 44}}, color = {0, 0, 127}));
    annotation(
      Documentation(info = "<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial ICE model with torque input in Newton-metres. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Models that inherit from this:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- partialIceP that contains an in ternal loop so that the request from the exterior is now in power instead of torque</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceP used when ICE must follow a Power request </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceConnP used when ICE must follow a Power request through an expandable connector</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceConnPOO used when ICE must follow a Power request through an expandable connector, and also ON7Off can be commanded from the outside</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceT used when ICE must follow a Torque request </span></p>
<p><span style=\"font-family: Arial;\">See their documentation for further details or Appendix 3 in EHPTexamples tutorial for the general taxonomy of ICE based models.</span></p>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{76, 10}, {100, -10}}), Rectangle(extent = {{-90, 48}, {-32, -46}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-90, 2}, {-32, -20}}), Line(points = {{-60, 36}, {-60, 12}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}})}),
      Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false), graphics = {Line(points = {{-50, 84}, {-36, 84}}, color = {255, 0, 0})}));
  end PartialIceTNm;

  partial model PartialIceT01 "Partial map-based ice model"
    import Modelica.Constants.*;
    extends PartialIceBase;
    parameter Modelica.Units.SI.MomentOfInertia iceJ = 0.5 "ICE moment of Inertia";
    // rad/s
    parameter String mapsFileName = "NoName" "File where specific consumption matrix is stored" annotation(
      Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String specConsName = "NoName" "name of the on-file specific consumption variable" annotation(
      Dialog(enable = mapsOnFile));
    Modelica.Blocks.Tables.CombiTable1Dv toLimTau(table = maxIceTau, tableOnFile = mapsOnFile, tableName = "maxIceTau", fileName = mapsFileName) annotation(
      Placement(visible = true, transformation(origin = {-72, 84}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
    Modelica.Blocks.Sources.RealExpression rotorW(y = wSensor.w) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-88, 28})));
    Modelica.Blocks.Math.Product product annotation(
      Placement(transformation(extent = {{-34, 68}, {-14, 88}})));
    Modelica.Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = 1) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-60, -24})));
    SupportModels.Miscellaneous.Gain fromPuTorque(k = nomTorque) annotation(
      Placement(visible = true, transformation(origin = {-48, 84}, extent = {{6, -6}, {-6, 6}}, rotation = 180)));
    SupportModels.Miscellaneous.Gain toPuSpeed1(k = 1/nomSpeed) annotation(
      Placement(visible = true, transformation(origin = {-88, 58}, extent = {{6, -6}, {-6, 6}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput nTauRef "normalized torque request" annotation(
      Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -98}), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -120})));
  equation
    connect(product.y, iceTau.tau) annotation(
      Line(points = {{-13, 78}, {2, 78}}, color = {0, 0, 127}));
    connect(product.u2, limiter.y) annotation(
      Line(points = {{-36, 72}, {-60, 72}, {-60, -13}}, color = {0, 0, 127}));
    connect(limiter.u, nTauRef) annotation(
      Line(points = {{-60, -36}, {-60, -98}}, color = {0, 0, 127}));
    connect(toLimTau.y[1], fromPuTorque.u) annotation(
      Line(points = {{-61, 84}, {-55.2, 84}}, color = {0, 0, 127}));
    connect(fromPuTorque.y, product.u1) annotation(
      Line(points = {{-41.4, 84}, {-36, 84}}, color = {0, 0, 127}));
    connect(toLimTau.u[1], toPuSpeed1.y) annotation(
      Line(points = {{-84, 84}, {-88, 84}, {-88, 64.6}}, color = {0, 0, 127}));
    connect(toPuSpeed1.u, rotorW.y) annotation(
      Line(points = {{-88, 50.8}, {-88, 39}}, color = {0, 0, 127}));
    annotation(
      Documentation(info = "<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial ICE model with torque input in per unit of the maximum torque. Models that inherit from this:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceT01 used when ICE must follow a Torque request in per unit of the maximum torque.</span></p>
<p>See its documentation for further details or Appendix 3 in EHPTexamples tutorial for the general taxonomy of ICE based models.</p>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Text(origin = {0, 10}, lineColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 48}, {-32, -46}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-90, 2}, {-32, -20}}), Line(points = {{-60, 36}, {-60, 12}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}})}),
      Diagram(coordinateSystem(preserveAspectRatio = false)));
  end PartialIceT01;

  partial model PartialIceP "Extends PartialIce0 adding power input"
    extends PartialIceTNm;
    Modelica.Blocks.Math.Feedback feedback annotation(
      Placement(transformation(extent = {{-98, 94}, {-78, 74}})));
    Modelica.Blocks.Math.Gain gain(k = contrGain) annotation(
      Placement(visible = true, transformation(extent = {{-70, 78}, {-58, 90}}, rotation = 0)));
  equation
    connect(gain.u, feedback.y) annotation(
      Line(points = {{-71.2, 84}, {-79, 84}}, color = {0, 0, 127}));
    connect(feedback.u2, icePow.power) annotation(
      Line(points = {{-88, 92}, {-88, 98}, {68, 98}, {68, 89}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(min1.u1, gain.y) annotation(
      Line(points = {{-36, 84}, {-57.4, 84}}, color = {0, 0, 127}));
    annotation(
      Documentation(info = "<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basic partial ICE model. Models that inherit from this:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceT used when ICE must follow a Torque request </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceP used when ICE must follow a Power request </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceConnP used when ICE must follow a Power request trhough an expandable connector</span></p>
<p>Data for tables (here called &quot;maps&quot;) can be set manually or loaded from a file.</p>
<h4>Inherited models connect torque request to the free input of min() block.</h4>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 62}, {100, -100}}), Text(origin = {0, 10}, textColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 48}, {-32, -46}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}}), Text(textColor = {162, 29, 33}, extent = {{-90, -52}, {-36, -84}}, textString = "P", textStyle = {TextStyle.Bold, TextStyle.Italic})}),
      Diagram(coordinateSystem(extent = {{-140, -100}, {100, 100}}, preserveAspectRatio = false), graphics = {Line(points = {{-110, 84}, {-96, 84}}, color = {255, 0, 0}), Text(extent = {{-98, -64}, {-54, -100}}, textString = "follows the power
reference \nand computes consumption")}));
  end PartialIceP;

  partial model PartialGenset "GenSet GMS+GEN+SEngine"
    import Modelica.Constants.inf;
    import Modelica.Constants.pi;
    // General parameters:
    parameter Real gsRatio = 1 "IdealGear speed reduction factor";
    parameter Real throttlePerWerr = 10/maxGenW "internal throttle controller proportional gain";
    // Parameters related to input maps:
    // ICE related parameters:
    parameter Modelica.Units.SI.MomentOfInertia jIce = 0.1 "ICE moment of inertia" annotation(
      Dialog(group = "ICE parameters"));
    parameter Boolean useNormalisedFuelMaps = false "= true, ICE consumption map has torque and speed between 0 and 1; else between 0 and maxTauNorm and maxSpeedNorm" annotation(
      choices(checkBox = true));
    parameter Modelica.Units.SI.AngularVelocity wIceStart = 167 annotation(
      Dialog(group = "ICE parameters"));
    // generator related parameters:
    parameter Modelica.Units.SI.MomentOfInertia jGen = 0.1 "Generator moment of inertia" annotation(
      Dialog(group = "Generator parameters"));
    parameter Modelica.Units.SI.AngularVelocity maxGenW = 1e6 "Max generator angular speed" annotation(
      Dialog(group = "Generator parameters"));
    parameter Modelica.Units.SI.Power maxGenPow = 100e3 "Max mechanical power of the internal generator" annotation(
      Dialog(group = "Generator parameters"));
    parameter String mapsFileName = "maps.txt" "File containing data maps (maxIceTau, gensetDriveEffTable, specificCons, optiSpeed)" annotation(
      Dialog(group = "Input map (ICE and Gen) parameters"));
    parameter Modelica.Units.SI.Torque maxTau = 200 "Max mechanical torque between internal ICE and generator";
    parameter Modelica.Units.SI.Torque maxTauNorm = maxTau "Max torque for normalised maps" annotation(
      Dialog(group = "Input map (ICE and Gen) parameters"));
    parameter Modelica.Units.SI.AngularVelocity maxSpeedNorm "Max mechanical speed for normalised maps" annotation(
      Dialog(group = "Input map (ICE and Gen) parameters"));
    final parameter Modelica.Units.SI.Torque actualTauMax(fixed = false);
    //actual Max torque value for consumption map (which in file is between 0 and 1)
    final parameter Modelica.Units.SI.AngularVelocity actualSpeedMax(fixed = false);
    //actual Max speed value for consumption map (which in file is between 0 and 1)
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
      Placement(transformation(extent = {{-8, -8}, {8, 8}}, rotation = 180, origin = {-20, -40})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor icePow annotation(
      Placement(transformation(extent = {{28, -16}, {46, 2}})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(extent = {{90, 50}, {110, 70}}), iconTransformation(extent = {{90, 50}, {110, 70}})));
    Modelica.Blocks.Nonlinear.Limiter limiter(uMax = inf, uMin = 0) annotation(
      Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = 90, origin = {-80, 48})));
    EHPTlib.MapBased.OneFlange gen(wMax = maxGenW, J = jGen, limitsFileName = mapsFileName, effMapOnFile = true, powMax = maxGenPow, tauMax = maxTau, effMapFileName = mapsFileName, effTableName = "gensetDriveEffTable") annotation(
      Placement(visible = true, transformation(extent = {{74, 2}, {54, -18}}, rotation = 0)));
    IceT01 iceT(iceJ = jIce, mapsOnFile = true, nomTorque = actualTauMax, nomSpeed = actualSpeedMax, mapsFileName = mapsFileName, wIceStart = wIceStart, specConsName = "specificCons") annotation(
      Placement(transformation(extent = {{-28, -18}, {-8, 4}})));
    Modelica.Blocks.Math.Gain gain(k = -gsRatio) annotation(
      Placement(transformation(extent = {{14, 24}, {34, 44}})));
    Modelica.Blocks.Math.Gain gain1(k = 1) annotation(
      Placement(visible = true, transformation(origin = {-80, -24}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
    Modelica.Blocks.Continuous.Integrator toFuelGrams(k = 1/3600) annotation(
      Placement(transformation(extent = {{24, -52}, {44, -32}})));
    Modelica.Mechanics.Rotational.Components.IdealGear idealGear(ratio = gsRatio) annotation(
      Placement(visible = true, transformation(extent = {{4, -16}, {22, 2}}, rotation = 0)));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(extent = {{90, -46}, {110, -26}}), iconTransformation(extent = {{92, -70}, {112, -50}})));
    Modelica.Blocks.Interfaces.RealInput powRef(unit = "W") "Reference genset power" annotation(
      Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = 90, origin = {60, 82}), iconTransformation(extent = {{15, -15}, {-15, 15}}, rotation = 90, origin = {57, 115})));
  initial equation
    if useNormalisedFuelMaps then
      actualTauMax = maxTauNorm;
      actualSpeedMax = maxSpeedNorm;
    else
      actualTauMax = 1;
      actualSpeedMax = 1;
    end if;
  equation
    connect(gain.y, gen.tauRef) annotation(
      Line(points = {{35, 34}, {80, 34}, {80, -8}, {75.4, -8}}, color = {0, 0, 127}));
    connect(gen.pin_n, pin_p) annotation(
      Line(points = {{74, -4}, {84, -4}, {84, 60}, {100, 60}}, color = {0, 0, 255}));
    connect(icePow.flange_b, gen.flange_a) annotation(
      Line(points = {{46, -7}, {50, -7}, {50, -8}, {54, -8}}));
    connect(gain1.u, speedSensor.w) annotation(
      Line(points = {{-80, -31.2}, {-80, -40}, {-28.8, -40}}, color = {0, 0, 127}));
    connect(limiter.u, powRef) annotation(
      Line(points = {{-80, 60}, {-80, 68}, {60, 68}, {60, 82}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(speedSensor.flange, iceT.flange_a) annotation(
      Line(points = {{-12, -40}, {-2, -40}, {-2, -7}, {-8, -7}}, color = {0, 0, 0}));
    connect(toFuelGrams.u, iceT.fuelCons) annotation(
      Line(points = {{22, -42}, {12, -42}, {12, -26}, {-12, -26}, {-12, -19.1}}, color = {0, 0, 127}));
    connect(idealGear.flange_a, iceT.flange_a) annotation(
      Line(points = {{4, -7}, {-8, -7}}, color = {0, 0, 0}));
    connect(idealGear.flange_b, icePow.flange_a) annotation(
      Line(points = {{22, -7}, {28, -7}}, color = {0, 0, 0}));
    connect(gen.pin_p, pin_n) annotation(
      Line(points = {{74, -12}, {74, -36}, {100, -36}}, color = {0, 0, 255}));
    annotation(
      Evaluate = true,
      HideResult = true,
      choices(checkBox = true),
      Dialog(group = "Input map (ICE and Gen) parameters"),
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 80}})),
      Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-98, 94}, {82, 68}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name"), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-20, 0}, {26, -14}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-44, 30}, {-14, -44}}), Line(points = {{-72, 30}, {-72, 6}}), Polygon(points = {{-72, -2}, {-78, 8}, {-66, 8}, {-72, -2}}), Rectangle(extent = {{-96, 38}, {-50, -48}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-96, -6}, {-50, -24}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-78, -24}, {-68, -44}}), Polygon(points = {{-72, 34}, {-78, 24}, {-66, 24}, {-72, 34}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{6, 30}, {62, -44}}), Line(points = {{94, 60}, {74, 60}, {74, 18}, {62, 18}}, color = {0, 0, 255}), Line(points = {{100, -60}, {74, -60}, {74, -28}, {62, -28}}, color = {0, 0, 255})}),
      Documentation(info = "<html>
</html>"));
  end PartialGenset;
end Partial;
