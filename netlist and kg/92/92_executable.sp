* Diff pair + diode-connected PMOS pulls, NMOS sink loads (VB2), tail NMOS (VB1) — runnable

***** Parameters (X) *****
.param VDD=1.8
.param VCM=0.8           ; input common-mode
.param VID=10m           ; differential amplitude

.param WN=10u  LN=0.5u   ; NMOS input pair size (M0,M2)
.param WTAIL={2*WN} LTAIL={LN}     ; NMOS tail (M1)
.param WNLOAD={WN} LNLOAD={LN}     ; NMOS sink loads (M5,M6)
.param WP=20u  LP=0.5u             ; PMOS diode loads (M3,M4)

.param VBIAS1=1.0        ; VB1: tail bias (sets tail current)
.param VBIAS2=0.6        ; VB2: NMOS sink-load gate bias
.param RLINK=10k         ; inter-branch resistor (net017 <-> net014)
.param CL=10f            ; small output caps (optional)

***** Supplies *****
VDD  VDD  0  {VDD}
VVSS VSS  0  0

***** Inputs (DC differential around VCM) *****
VIN1 VIN1 0 {VCM + VID/2}
VIN2 VIN2 0 {VCM - VID/2}

***** Biases *****
Vb1  VB1  0 {VBIAS1}
Vb2  VB2  0 {VBIAS2}

***** Devices *****
* NMOS differential pair (share tail node net016)
M2  net017 VIN2 net016 VSS  nmos4  W={WN}      L={LN}
M0  net014 VIN1 net016 VSS  nmos4  W={WN}      L={LN}

* NMOS tail current source (gate-biased by VB1)
M1  net016 VB1  VSS   VSS  nmos4  W={WTAIL}   L={LTAIL}

* NMOS sink loads per branch (gate-biased by VB2)
M6  VOUT2  VB2  net017 VSS  nmos4  W={WNLOAD}  L={LNLOAD}
M5  VOUT1  VB2  net014 VSS  nmos4  W={WNLOAD}  L={LNLOAD}

* PMOS diode-connected loads to VDD (pull-ups)
M4  VOUT2  VOUT2 VDD   VDD  pmos4  W={WP}      L={LP}
M3  VOUT1  VOUT1 VDD   VDD  pmos4  W={WP}      L={LP}

* Inter-branch resistor between drains of input NMOS
R0  net017 net014 {RLINK}

* Optional output load caps
CL1 VOUT1 0 {CL}
CL2 VOUT2 0 {CL}

***** Simple MOS models (placeholders) *****
.model nmos4 NMOS (LEVEL=1 VTO=0.70 KP=120e-6 LAMBDA=0.04 GAMMA=0.5 PHI=0.6)
.model pmos4 PMOS (LEVEL=1 VTO=-0.70 KP=50e-6  LAMBDA=0.04 GAMMA=0.5 PHI=0.6)

***** Analyses *****
.op
*.ac dec 100 1 1e9
*.tran 1u 200u
.save v(vout1) v(vout2) v(net014) v(net017) v(net016) v(vb1) v(vb2) i(VDD)

.options post=2 nomod
.end
