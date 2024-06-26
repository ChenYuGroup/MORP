%% Ev3 (glucose+trehalose)  maximize growth
Sg=zeros(13,1);
Sg(1)=111.14;% initial glucose concentration for the first step (mmol/L)
Slt=zeros(13,1);
Slt(1)=0;% initial lactate concentration for the first step (mmol/L)
dcwt=zeros(13,1);
dcwt(1)=0.237;% initial biomass for the first step (g/L)
v1=zeros(13,1);
vmaxt=8.8;% maximum trehalose specific consumption rate (mmol/gDCW/h)
Kmt=32.8;% trehalose saturation constant (mmol/L)
St=zeros(13,1);
St(1)=58.36;% initial trehalose concentration for the first step (mmol/L)
v2=zeros(13,1);
v2(1)=vmaxt*St(1)/(Kmt+St(1));
miu=zeros(13,1);
vlt=zeros(13,1);
FBAg=zeros(2460,13);
for j=1:12
    v1(j)=0.3699*v2(j);
    model_ALE(j) = ecModel;
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0003',0.03*v2(j),'b');%CO2
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0004',-0.0024*v2(j),'b');%O2
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0068',0.15*v2(j),'b');%acetate
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0069',0.0134*v2(j),'b');%citrate
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0070',0.0095*v2(j),'b');%pyruvate
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0027',0.1185*v2(j),'b');%acetoin
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0002',4.06*v2(j),'b');%lactate
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0001',-v1(j),'b');%glucose
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0064',-v2(j),'b');%trehalose
    model_ALE(j) = changeObjective(model_ALE(j),'EXBiomass');
    FBAsolution = optimizeCbModel(model_ALE(j),'max','one');
    vlt(j)=FBAsolution.x(3);
    miu(j)=FBAsolution.x(86);
    dcwt(j+1)=exp(miu(j)*1+log(dcwt(j)));% initial biomass fo the next step (g/L)
    Sg(j+1)=Sg(j)-v1(j)/miu(j)*(dcwt(j+1)-dcwt(j));% initial glucose concentration for the next step (mmol/L)
    St(j+1)=St(j)-v2(j)/miu(j)*(dcwt(j+1)-dcwt(j));% initial trehalose concentration for the next step (mmol/L)
    Slt(j+1)=Slt(j)+vlt(j)/miu(j)*(dcwt(j+1)-dcwt(j));% initial lactate concentration for the next step (mmol/L)
    v2(j+1)=vmaxt*St(j+1)/(Kmt+St(j+1));% trehalose specific consumption rate for the next step (mmol/gDCW/h)
    FBAg(:,j)=FBAsolution.x;
end
%% secondary simulation (minimizied protein production)
Sg=zeros(13,1);
Sg(1)=111.14;% initial glucose concentration for the first step (mmol/L)
Slt=zeros(13,1);
Slt(1)=0;% initial lactate concentration for the first step (mmol/L)
dcwt=zeros(13,1);
dcwt(1)=0.237;% initial biomass for the first step (g/L)
v1=zeros(13,1);
vmaxt=8.8;% maximum trehalose specific consumption rate (mmol/gDCW/h)
Kmt=32.8;% trehalose saturation constant (mmol/L)
St=zeros(13,1);
St(1)=58.36;% initial trehalose concentration for the first step (mmol/L)
v2=zeros(13,1);
v2(1)=vmaxt*St(1)/(Kmt+St(1));
vlt=zeros(13,1);
FBAg=zeros(2460,13);
for j=1:12
    v1(j)=0.3699*v2(j);
    model_ALE(j) = ecModel;
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0003',0.03*v2(j),'b');%CO2
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0004',-0.0024*v2(j),'b');%O2
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0068',0.15*v2(j),'b');%acetate
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0069',0.0134*v2(j),'b');%citrate
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0070',0.0095*v2(j),'b');%pyruvate
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0027',0.1185*v2(j),'b');%acetoin
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0002',4.06*v2(j),'b');%lactate
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0001',-v1(j),'b');%glucose
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EX0064',-v2(j),'b');%trehalose
    model_ALE(j) = changeRxnBounds(model_ALE(j),'EXBiomass',miu(j),'b');
    model_ALE(j) = changeObjective(model_ALE(j),'prot_pool_exchange');
    FBAsolution = optimizeCbModel(model_ALE(j),'max','one');
    vlt(j)=FBAsolution.x(3);
    miu(j)=FBAsolution.x(86);
    dcwt(j+1)=exp(miu(j)*1+log(dcwt(j)));% initial biomass fo the next step (g/L)
    Sg(j+1)=Sg(j)-v1(j)/miu(j)*(dcwt(j+1)-dcwt(j));% initial glucose concentration for the next step (mmol/L)
    St(j+1)=St(j)-v2(j)/miu(j)*(dcwt(j+1)-dcwt(j));% initial trehalose concentration for the next step (mmol/L)
    Slt(j+1)=Slt(j)+vlt(j)/miu(j)*(dcwt(j+1)-dcwt(j));% initial lactate concentration for the next step (mmol/L)
    v2(j+1)=vmaxt*St(j+1)/(Kmt+St(j+1));% trehalose specific consumption rate for the next step (mmol/gDCW/h)
    FBAg(:,j)=FBAsolution.x;
end
result_tre.rxns = ecModel.rxns;
result_tre.x = FBAsolution.x;
%% MORP
model_tre(1) = ecModel;
Sgm=zeros(10,1);
Sgm(1)=Sg(13);
Slm=zeros(10,1);
Slm(1)=Slt(13);
dcwm=zeros(10,1);
dcwm(1)=dcwt(13);
vmaxg=8.48;% maximum glucose specific consumption rate (mmol/gDCW/h)
Kmg=100;% glucose saturation constant (mmol/L)
vg=zeros(10,1);
vg(1)=vmaxg*Sgm(1)/(Kmg+Sgm(1));% glucose specific consumption rate for the first step (mmol/gDCW/h)
MORPm=zeros(2460,10);
model_morp(1)=ecModel;
%model_morp(1) = changeRxnBounds(model_morp(1),'EX0003',0.03*vg(1),'l');%CO2
%model_morp(1) = changeRxnBounds(model_morp(1),'EX0004',-0.0024*vg(1),'l');%O2
%model_morp(1) = changeRxnBounds(model_morp(1),'EX0068',0.0219*vg(1),'b');%acetate
%model_morp(1) = changeRxnBounds(model_morp(1),'EX0069',-0.0015*vg(1),'b');%citrate
%model_morp(1) = changeRxnBounds(model_morp(1),'EX0070',0.0004*vg(1),'b');%pyruvate
%model_morp(1) = changeRxnBounds(model_morp(1),'EX0027',0.0651*vg(1),'b');%acetoin
%model_morp(1) = changeRxnBounds(model_morp(1),'EX0002',1.76*vg(1),'b');%lactate
model_morp(1) = changeRxnBounds(model_morp(1),'EX0001',-vg(1),'b');%glucose
%model_morp(1) = changeRxnBounds(model_morp(1),'EX0064',0,'b');%trehalose
solMORP = MORP(model_morp(1),result_tre);
MORPm(:,1)=solMORP.x;
result_gluc(1).rxns = ecModel.rxns;
result_gluc(1).x = solMORP.x;
vlm(1)=solMORP.x(3);
mium(1)=solMORP.x(86);
dcwm(2)=exp(mium(1)*1+log(dcwm(1)));
Sgm(2)=Sgm(1)-vg(1)/mium(1)*(dcwm(2)-dcwm(1));
Slm(2)=Slm(1)+vlm(1)/mium(1)*(dcwm(2)-dcwm(1));
vg(2)=vmaxg*Sgm(2)/(Kmg+Sgm(2));
for i=1:5
    model_morp(i+1) = ecModel;
    %model_morp(i+1) = changeRxnBounds(model_morp(i+1),'EX0003',0.03*vg(i+1),'l');%CO2
    %model_morp(i+1) = changeRxnBounds(model_morp(i+1),'EX0004',-0.0024*vg(i+1),'l');%O2
    %model_morp(i+1) = changeRxnBounds(model_morp(i+1),'EX0068',0.0219*vg(i+1),'b');%acetate
    %model_morp(i+1) = changeRxnBounds(model_morp(i+1),'EX0069',-0.0015*vg(i+1),'b');%citrate
    %model_morp(i+1) = changeRxnBounds(model_morp(i+1),'EX0070',0.0004*vg(i+1),'b');%pyruvate
    %model_morp(i+1) = changeRxnBounds(model_morp(i+1),'EX0027',0.0651*v1vg(i+1),'b');%acetoin
    %model_morp(i+1) = changeRxnBounds(model_morp(i+1),'EX0002',1.76*v1vg(i+1),'b');%lactate
    model_morp(i+1) = changeRxnBounds(model_morp(i+1),'EX0001',-vg(i+1),'b');%glucose
    %model_morp(i+1) = changeRxnBounds(model_morp(i+1),'EX0064',0,'b');%trehalose
    solMORP = MORP(model_morp(i+1),result_gluc(i));
    MORPm(:,i+1)=solMORP.x;
    result_gluc(i+1).rxns = ecModel.rxns;
    result_gluc(i+1).x = solMORP.x;
    vlm(i+1)=FBAsolution.x(3);
    mium(i+1)=FBAsolution.x(86);
    dcwm(i+2)=exp(mium(i+1)*1+log(dcwm(i+1)));% initial biomass fo the next step (g/L)
    Sgm(i+2)=Sgm(i+1)-vg(i+1)/mium(i+1)*(dcwm(i+2)-dcwm(i+1));% initial glucose concentration for the next step (mmol/L)
    Slm(i+2)=Slm(i+1)+vlm(i+1)/mium(i+1)*(dcwm(i+2)-dcwm(i+1));% initial lactate concentration for the next step (mmol/L)
    vg(i+2)=vmaxg*Sgm(i+2)/(Kmg+Sgm(i+2));% glucose specific consumption rate for the next step (mmol/gDCW/h)
end