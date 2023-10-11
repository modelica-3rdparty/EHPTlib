within EHPTlib.MapBased;
model TwoFlangeConn "Simple map-based two-flange electric drive model"
  extends EHPTlib.MapBased.Partial.PartialTwoFlange;
  SupportModels.ConnectorRelated.Conn conn1 annotation (
    Placement(visible = true, transformation(extent={{-108,-58},{-68,-98}},      rotation = 0), iconTransformation(extent={{-108,
            -58},{-68,-98}},                                                                                                                           rotation = 0)));
equation
  connect(outBPow_.power, conn1.motPowDelB) annotation (
    Line(points={{64,39},{64,-78},{-88,-78},{-88,-78}},          color = {0, 0, 127}, smooth = Smooth.None),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(speedRing.w, conn1.motW) annotation (
    Line(points={{-80,29},{-86,29},{-86,28},{-88,28},{-88,-78}},            color = {0, 0, 127}, smooth = Smooth.None),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(add.y, conn1.motPowDelAB) annotation (
    Line(points={{32,-1},{32,-22},{78,-22},{78,-78},{-88,-78}},            color = {0, 0, 127}, smooth = Smooth.None),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(torqueLimiter.u, conn1.motTauRef) annotation (
    Line(points={{-18,2},{-26,2},{-26,-56},{-88,-56},{-88,-78}},            color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false,
    initialScale = 0.1, grid = {2, 2}), graphics={  Rectangle(fillColor = {192, 192, 192},
            fillPattern =                                                                                                                                                                        FillPattern.HorizontalCylinder, extent = {{-100, 10}, {-66, -10}}), Rectangle(fillColor = {192, 192, 192},
            fillPattern =                                                                                                                                                                                                        FillPattern.HorizontalCylinder, extent = {{66, 8}, {100, -12}}),                                                                 Line(origin = {20, -2}, points = {{-60, 94}, {-60, 76}}, color = {0, 0, 255}), Line(origin = {-20, -2}, points = {{60, 94}, {60, 76}}, color = {0, 0, 255})}),
    Documentation(info = "<html>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Simple map-based ICE model for power-split power trains - with connector</b> </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This is a &QUOT;connector&QUOT; version of MBice.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For a general descritiption see the info of MBice.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Signals connected to the connector:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- icePowRef (input) is the power request (W). Negative values are internally converted to zero</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- iceW (output) is the measured ICE speed (rad/s)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- icePowDel (output) delivered power (W)</span></p>
</html>"));
end TwoFlangeConn;
