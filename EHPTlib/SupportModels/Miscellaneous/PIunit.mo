within EHPTlib.SupportModels.Miscellaneous;
block PIunit
  extends Modelica.Blocks.Continuous.PI(k(unit = ""));
  annotation (
    Documentation(info = "<html><head></head><body>This model extends from MSL's PI, to allow using gain values with physical units: MSL uses unit=\"1\" for its gain parameter k.<div>Note that currently (2026) this is far from optimal.&nbsp;</div><div>Openmodelica is not able to deduce the output unit from input's and gain.</div><div>Dymola can, but infers \"J\" instead of N.m\". It is equivalent but misleading. To have \"N.m\" as output when this block is used, the user has still to set \"y(unit=\"N.m\"), which works also with the original MSL's PI.</div></body></html>"));
end PIunit;
