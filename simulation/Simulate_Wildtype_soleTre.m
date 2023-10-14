%% sole trehalose (maximize growth)
vmax=2.26;% maximum trehalose specific consumption rate (mmol/gDCW/h)
Km=32.8;% trehalose saturation constant (mmol/L)
St=zeros(83,1);
St(1)=116.85;% initial trehalose concentration for the first step (mmol/L)
Sl=zeros(83,1);
Sl(1)=0;% initial lactate concentration for the first step (mmol/L)
dcw=zeros(83,1);
dcw(1)=0.2;% initial biomass for the first step (g/L)
v=zeros(83,1);
v(1)=vmax*St(1)/(Km+St(1));% trehalose specific consumption rate for the first step (mmol/gDCW/h)
miu=zeros(83,1);
vl=zeros(83,1);
FBA=zeros(2460,83);
for i=1:83
    model_dynamic = ecModel;
    model_dynamic = changeRxnBounds(model_dynamic,'EX0064',-v(i),'b');%tre
    model_dynamic = changeRxnBounds(model_dynamic,'EX0001',0,'b');
    model_dynamic = changeRxnBounds(model_dynamic,'EX0003',0.0572*v(i),'b');%CO2
    model_dynamic = changeRxnBounds(model_dynamic,'EX0004',-0.0249*v(i),'b');%O2
    model_dynamic = changeRxnBounds(model_dynamic,'EX0068',0.3*v(i),'b');%acetate
    model_dynamic = changeRxnBounds(model_dynamic,'EX0069',-0.033*v(i),'l');%citrate
    model_dynamic = changeRxnBounds(model_dynamic,'EX0070',0.0003*v(i),'b');%pyruvate
    model_dynamic = changeRxnBounds(model_dynamic,'EX0027',0.037*v(i),'b');%acetoin
    model_dynamic = changeRxnBounds(model_dynamic,'EX0002',3.6*v(i),'b');%lactate
    model_dynamic = changeRxnBounds(model_dynamic,'EX0014',-0.2,'l');%ala
    model_dynamic = changeRxnBounds(model_dynamic,'EX0017',-0.2,'l');%glu
    model_dynamic = changeRxnBounds(model_dynamic,'EX0015',-0.2,'l');%arg
    model_dynamic = changeRxnBounds(model_dynamic,'EX0022',-0.2,'l');%thr

    model_dynamic = changeObjective(model_dynamic,'EXBiomass');
    FBAsolution = optimizeCbModel(model_dynamic,'max','one');
    vl(i)=FBAsolution.x(3);
    miu(i)=FBAsolution.x(86);
    St(i+1)=St(i)-v(i)*dcw(i)*1;% initial trehalose concentration for the next step (mmol/L)
    dcw(i+1)=exp(miu(i)*1+log(dcw(i)));% initial biomass fo the next step (g/L)
    Sl(i+1)=Sl(i)+vl(i)*dcw(i);% initial lactate concentration for the next step (mmol/L)
    v(i+1)=vmax*St(i+1)/(Km+St(i+1));% trehalose specific consumption rate for the next step (mmol/gDCW/h)
    FBA(:,i)=FBAsolution.x; 
end
%% secondary simulation (minimizied protein production)
vmax=2.26;% maximum trehalose specific consumption rate (mmol/gDCW/h)
Km=32.8;% trehalose saturation constant (mmol/L)
St=zeros(83,1);
St(1)=116.85;% initial trehalose concentration for the first step (mmol/L)
Sl=zeros(83,1);
Sl(1)=0;% initial lactate concentration for the first step (mmol/L)
dcw=zeros(83,1);
dcw(1)=0.2;% initial biomass for the first step (g/L)
v=zeros(83,1);
v(1)=vmax*St(1)/(Km+St(1));% trehalose specific consumption rate for the first step (mmol/gDCW/h)
vl=zeros(83,1);
FBA=zeros(2460,83);
for i=1:83
    model_dynamic = ecModel;
    model_dynamic = changeRxnBounds(model_dynamic,'EX0064',-v(i),'b');%tre
    model_dynamic = changeRxnBounds(model_dynamic,'EX0001',0,'b');
    model_dynamic = changeRxnBounds(model_dynamic,'EX0003',0.0572*v(i),'b');%CO2
    model_dynamic = changeRxnBounds(model_dynamic,'EX0004',-0.0249*v(i),'b');%O2
    model_dynamic = changeRxnBounds(model_dynamic,'EX0068',0.3*v(i),'b');%acetate
    model_dynamic = changeRxnBounds(model_dynamic,'EX0069',-0.033*v(i),'l');%citrate
    model_dynamic = changeRxnBounds(model_dynamic,'EX0070',0.0003*v(i),'b');%pyruvate
    model_dynamic = changeRxnBounds(model_dynamic,'EX0027',0.037*v(i),'b');%acetoin
    model_dynamic = changeRxnBounds(model_dynamic,'EX0002',3.6*v(i),'b');%lactate
    model_dynamic = changeRxnBounds(model_dynamic,'EXBiomass',miu(i),'b');

    model_dynamic = changeRxnBounds(model_dynamic,'EX0014',-0.2,'l');%ala
    model_dynamic = changeRxnBounds(model_dynamic,'EX0017',-0.2,'l');%glu
    model_dynamic = changeRxnBounds(model_dynamic,'EX0015',-0.2,'l');%arg
    model_dynamic = changeRxnBounds(model_dynamic,'EX0022',-0.2,'l');%thr

    model_dynamic = changeObjective(model_dynamic,'prot_pool_exchange');
    FBAsolution = optimizeCbModel(model_dynamic,'max','one');
    vl(i)=FBAsolution.x(3);
    miu(i)=FBAsolution.x(86);
    St(i+1)=St(i)-v(i)*dcw(i)*1;% initial trehalose concentration for the next step (mmol/L)
    dcw(i+1)=exp(miu(i)*1+log(dcw(i)));% initial biomass fo the next step (g/L)
    Sl(i+1)=Sl(i)+vl(i)*dcw(i);% initial lactate concentration for the next step (mmol/L)
    v(i+1)=vmax*St(i+1)/(Km+St(i+1));% trehalose specific consumption rate for the next step (mmol/gDCW/h)
    FBA(:,i)=FBAsolution.x; 
end