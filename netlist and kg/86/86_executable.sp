* Diff pair + PMOS load + resistive CMFB, NMOS tail via VB1 (runnable)

***** Parameters (X) *****
.param VDD=1.8
.param RCM=20k
.param WN=10u  LN=0.5u          ; input pair NMOS size
.param WP=20u  LP=0.5u          ; PMOS load size
.param WNTAIL={2*WN} LNTAIL={LN}; tail NMOS size (can tune)
.param VBIAS=1.0                ; gate bias for tail NMOS (set tail current)

***** Operating Parameters *****
.param VCM=0.8
.param VID=10m                  ; differential amplitude

***** Supplies *****
VDD  VDD 0 {VDD}
VVSS VSS 0 0

***** Inputs (DC differential around VCM) *****
VIN1 VIN1 0 {VCM + VID/2}
VIN2 VIN2 0 {VCM - VID/2}

***** Tail bias *****
Vb   VB1 0 {VBIAS}

***** Devices *****
* NMOS differential pair (share tail node net08)
M2  VOUT2 VIN2 net08 VSS  nmos4 W={WN}     L={LN}
M0  VOUT1 VIN1 net08 VSS  nmos4 W={WN}     L={LN}

* NMOS tail current device (gate-biased by VB1)
M1  net08  VB1  VSS  VSS  nmos4 W={WNTAIL} L={LNTAIL}

* PMOS active loads (gates tied via resistive CMFB)
M4  VOUT2 net010 VDD VDD  pmos4 W={WP}     L={LP}
M3  VOUT1 net010 VDD VDD  pmos4 W={WP}     L={LP}

* Resistive CMFB averaging VOUT1/2 to the PMOS gates
R1  VOUT2 net010 {RCM}
R0  net010 VOUT1 {RCM}

***** Simple MOS models (portable placeholders) *****
.model nmos4 NMOS (LEVEL=1 VTO=0.70 KP=120e-6 LAMBDA=0.04 GAMMA=0.5 PHI=0.6)
.model pmos4 PMOS (LEVEL=1 VTO=-0.70 KP=50e-6  LAMBDA=0.04 GAMMA=0.5 PHI=0.6)

***** Analyses *****
.op
*.ac dec 100 1 1e9              
*.tran 1u 200u
*.save v(vout1) v(vout2) v(net010) v(net08) i(VDD)

.options post=2 nomod
.end