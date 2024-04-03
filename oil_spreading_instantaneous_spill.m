function out = model
%
% oil_spreading_instantaneous_spill.m
%


import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('D:\_OneDrive\Metu\OneDrive - metu.edu.tr\PETE\_Makaleler\Oil_Spreading\Makale_1_finite_element\4_Environmental Modeling and Software\Github\1_instantaneous_spill');

model.label('oil_spreading_instantaneous_spill.mph');

model.param.set('r_i', '36.63[m]');
model.param.set('a', '2*pi/3/Volume*(2*gamma/g_prime/density_o)^(1/2)');
model.param.set('Volume', '200[m^3]');
model.param.set('gamma', '0.00001 [kg/s^2]', 'surface tension parameter');
model.param.set('g_prime', '(density_w-density_o)/density_o*gravity');
model.param.set('density_w', '1025[kg/m^3]');
model.param.set('density_o', '890 [kg/m^3]');
model.param.set('gravity', '9.81 [m/s^2]');
model.param.set('k', '0.003 [kg/m^2/s]');
model.param.set('time', '0.1 [s]');
model.param.set('function_value', 'r_i^2-1/a*atan(a*r_i^2)-4*gamma/k*time');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.result.table.create('tbl1', 'Table');
model.result.evaluationGroup.create('eg1', 'EvaluationGroup');
model.result.evaluationGroup('eg1').create('gev1', 'EvalGlobal');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('sq1', 'Square');
model.component('comp1').geom('geom1').feature('sq1').set('pos', [0 0]);
model.component('comp1').geom('geom1').feature('sq1').set('size', 600);
model.component('comp1').geom('geom1').create('c1', 'Circle');
model.component('comp1').geom('geom1').feature('c1').set('pos', [300 300]);
model.component('comp1').geom('geom1').feature('c1').set('r', 'r_i');
model.component('comp1').geom('geom1').create('sq2', 'Square');
model.component('comp1').geom('geom1').feature('sq2').set('pos', [0 0]);
model.component('comp1').geom('geom1').feature('sq2').set('size', 300);
model.component('comp1').geom('geom1').create('sq3', 'Square');
model.component('comp1').geom('geom1').feature('sq3').set('pos', [300 0]);
model.component('comp1').geom('geom1').feature('sq3').set('size', 300);
model.component('comp1').geom('geom1').create('sq4', 'Square');
model.component('comp1').geom('geom1').feature('sq4').set('pos', [0 300]);
model.component('comp1').geom('geom1').feature('sq4').set('size', 300);
model.component('comp1').geom('geom1').create('sq5', 'Square');
model.component('comp1').geom('geom1').feature('sq5').set('pos', [300 300]);
model.component('comp1').geom('geom1').feature('sq5').set('size', 300);
model.component('comp1').geom('geom1').run;

model.component('comp1').variable.create('var1');
model.component('comp1').variable('var1').set('h_max', 'comp1.at0(300,300,h)');
model.component('comp1').variable('var1').set('c_coeff', '(g_prime*density_o/k+2*gamma/k/h_max^2)*h^2');

model.component('comp1').physics.create('c', 'CoefficientFormPDE', 'geom1');
model.component('comp1').physics('c').field('dimensionless').field('h');
model.component('comp1').physics('c').field('dimensionless').component({'h'});
model.component('comp1').physics('c').prop('Units').set('DependentVariableQuantity', 'none');
model.component('comp1').physics('c').create('init2', 'init', 2);
model.component('comp1').physics('c').feature('init2').selection.set([1 2 5 8]);
model.component('comp1').physics('c').create('dir1', 'DirichletBoundary', 1);
model.component('comp1').physics('c').feature('dir1').selection.set([1 2 3 5 8 13 15 16]);
model.component('comp1').physics.create('ge', 'GlobalEquations', 'geom1');
model.component('comp1').physics('ge').feature('ge1').set('DependentVariableQuantity', 'none');

model.component('comp1').mesh('mesh1').autoMeshSize(2);

model.component('comp1').probe.create('dom1', 'Domain');

model.result.table('tbl1').label('Probe Table 1');

model.component('comp1').view('view1').axis.set('xmin', -216.88775634765625);
model.component('comp1').view('view1').axis.set('xmax', 816.8877563476562);
model.component('comp1').view('view1').axis.set('ymin', -46.83673095703125);
model.component('comp1').view('view1').axis.set('ymax', 646.8367309570312);

model.component('comp1').physics('c').prop('Units').set('CustomSourceTermUnit', 'm/s');
model.component('comp1').physics('c').feature('cfeq1').set('c', {'c_coeff' '0' '0' 'c_coeff'});
model.component('comp1').physics('c').feature('cfeq1').set('f', 0);
model.component('comp1').physics('c').feature('init1').set('h', 'Volume/pi/r_i^2');
model.component('comp1').physics('ge').feature('ge1').set('name', 'radius_initial');
model.component('comp1').physics('ge').feature('ge1').set('equation', 'radius_initial^2-1/a*atan(a*radius_initial^2)-4*gamma/k*time');
model.component('comp1').physics('ge').feature('ge1').set('initialValueU', 10);
model.component('comp1').physics('ge').feature('ge1').set('SourceTermQuantity', 'none');
model.component('comp1').physics('ge').feature('ge1').set('CustomSourceTermUnit', 'm^2');

model.component('comp1').probe('dom1').set('type', 'maximum');
model.component('comp1').probe('dom1').set('probename', 'hmax');
model.component('comp1').probe('dom1').set('table', 'tbl1');
model.component('comp1').probe('dom1').set('window', 'window1');

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').set('activate', {'c' 'off' 'ge' 'on' 'frame:spatial1' 'on' 'frame:material1' 'on'});
model.study.create('std2');
model.study('std2').create('time', 'Transient');
model.study('std2').feature('time').set('activate', {'c' 'on' 'ge' 'off' 'frame:spatial1' 'on' 'frame:material1' 'on'});

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol.create('sol2');
model.sol('sol2').study('std2');
model.sol('sol2').attach('std2');
model.sol('sol2').create('st1', 'StudyStep');
model.sol('sol2').create('v1', 'Variables');
model.sol('sol2').create('t1', 'Time');
model.sol('sol2').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol2').feature('t1').feature.remove('fcDef');

model.result.dataset.create('dset3', 'Solution');
model.result.dataset.create('max1', 'Maximum');
model.result.dataset.create('cln1', 'CutLine2D');
model.result.dataset('dset3').set('probetag', 'dom1');
model.result.dataset('dset3').set('solution', 'sol2');
model.result.dataset('max1').set('probetag', 'dom1');
model.result.dataset('max1').set('data', 'dset3');
model.result.dataset('max1').selection.geom('geom1', 2);
model.result.dataset('max1').selection.set([1 2 3 4 5 6 7 8]);
model.result.dataset('cln1').set('data', 'dset2');
model.result.numerical.create('pev1', 'EvalPoint');
model.result.numerical('pev1').set('probetag', 'dom1');
model.result.create('pg1', 'PlotGroup2D');
model.result.create('pg2', 'PlotGroup2D');
model.result.create('pg3', 'PlotGroup1D');
model.result.create('pg4', 'PlotGroup1D');
model.result('pg1').set('data', 'dset2');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').create('surf2', 'Surface');
model.result('pg1').feature('surf2').set('expr', 'maxop1(u2)');
model.result('pg2').set('data', 'dset2');
model.result('pg2').create('surf1', 'Surface');
model.result('pg3').set('probetag', 'window1_default');
model.result('pg3').create('tblp1', 'Table');
model.result('pg3').feature('tblp1').set('probetag', 'dom1');
model.result('pg4').create('lngr1', 'LineGraph');

model.component('comp1').probe('dom1').genResult([]);

model.result('pg5').tag('pg3');

model.study('std2').feature('time').set('tunit', 'min');
model.study('std2').feature('time').set('tlist', 'range(0,0.1,18)');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').label('Compile Equations: Stationary');
model.sol('sol1').feature('v1').label('Dependent Variables 1.1');
model.sol('sol1').feature('s1').label('Stationary Solver 1.1');
model.sol('sol1').feature('s1').feature('dDef').label('Direct 1');
model.sol('sol1').feature('s1').feature('aDef').label('Advanced 1');
model.sol('sol1').feature('s1').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol1').runAll;
model.sol('sol2').attach('std2');
model.sol('sol2').feature('st1').label('Compile Equations: Time Dependent');
model.sol('sol2').feature('v1').label('Dependent Variables 1.1');
model.sol('sol2').feature('v1').set('clist', {'range(0,0.1,18)' '0.018000000000000002[min]'});
model.sol('sol2').feature('t1').label('Time-Dependent Solver 1.1');
model.sol('sol2').feature('t1').set('tunit', 'min');
model.sol('sol2').feature('t1').set('tlist', 'range(0,0.1,18)');
model.sol('sol2').feature('t1').feature('dDef').label('Direct 1');
model.sol('sol2').feature('t1').feature('aDef').label('Advanced 1');
model.sol('sol2').feature('t1').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol2').runAll;

model.result.dataset('dset3').label('Probe Solution 3');
model.result.dataset('cln1').set('genpoints', [300 300; 300 600]);
model.result.numerical('pev1').set('descr', {'Dependent variable h' 'Dependent variable R'});
model.result.evaluationGroup('eg1').set('data', 'dset1');
model.result.evaluationGroup('eg1').feature('gev1').set('expr', {'radius_initial' 'r_i^2-1/a*atan(a*r_i^2)-4*gamma/k*time'});
model.result.evaluationGroup('eg1').feature('gev1').set('unit', {'m' 'm^2'});
model.result.evaluationGroup('eg1').feature('gev1').set('descr', {'State variable radius_initial' 'function_value'});
model.result.evaluationGroup('eg1').run;
model.result('pg1').feature('surf1').set('smooth', 'internal');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf2').active(false);
model.result('pg1').feature('surf2').set('smooth', 'internal');
model.result('pg1').feature('surf2').set('resolution', 'normal');
model.result('pg2').set('looplevel', [1]);
model.result('pg2').feature('surf1').set('resolution', 'normal');
model.result('pg3').label('Probe Plot Group 3');
model.result('pg3').set('xlabel', 'Time (min)');
model.result('pg3').set('ylabel', 'Dependent variable h (m), Domain Probe 1');
model.result('pg3').set('windowtitle', 'Probe Plot 1');
model.result('pg3').set('xlabelactive', false);
model.result('pg3').set('ylabelactive', false);
model.result('pg4').set('data', 'cln1');
model.result('pg4').set('looplevelinput', {'manual'});
model.result('pg4').set('looplevel', [51]);
model.result('pg4').set('xlabel', 'Arc length (m)');
model.result('pg4').set('ylabel', 'Dependent variable h (m)');
model.result('pg4').set('xlabelactive', false);
model.result('pg4').set('ylabelactive', false);
model.result('pg4').feature('lngr1').set('resolution', 'normal');

out = model;
