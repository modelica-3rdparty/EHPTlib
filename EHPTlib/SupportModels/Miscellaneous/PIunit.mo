within EHPTlib.SupportModels.Miscellaneous;
block PIunit
  extends Modelica.Blocks.Continuous.PI(k(unit = ""));
  annotation (
    Documentation(info = "<html><head></head><body>This model extends from MSL's PI, to allow using gain values with physical units: MSL uses unit=\"1\" for its gain parameter k.</body></html>"));
end PIunit;
