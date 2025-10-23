* Diff pair + cross-coupled PMOS loads, NMOS tail via VB1 (runnable)

***** Parameters (X) *****
.param VDD=1.8
.param WN=10u  LN=0.5u               ; NMOS input pair size
.param WNTAIL={2*WN} LNTAIL={LN}     ; NMOS tail size
.param WP=20u  LP=0.5u               ; PMOS load size
.param VBIAS=1.0                     ; tail-gate bias (sets tail current)

***** Operating Parameters *****
.param VCM=0.8                       ; input common-mode
.param VID=10m                       ; differential amplitude (VIN1=+VID/2, VIN2=-VID/2)
.param CL=10f                        ; small output caps for stability/visibility (optional)

***** Supplies *****
VDD  VDD  0  {VDD}
VVSS VSS  0  0

***** Inputs (DC differential around VCM) *****
VIN1 VIN1 0 {VCM + VID/2}
VIN2 VIN2 0 {VCM - VID/2}

***** Tail bias *****
Vb   VB1  0 {VBIAS}

***** Devices *****
* NMOS differential pair (share tail node net017)
M2  VOUT2 VIN2 net017 VSS  nmos4  W={WN}     L={LN}
M0  VOUT1 VIN1 net017 VSS  nmos4  W={WN}     L={LN}

* NMOS tail current device (gate-biased by VB1)
M1  net017 VB1  VSS   VSS  nmos4  W={WNTAIL} L={LNTAIL}

* Cross-coupled PMOS loads (provide positive feedback / regeneration)
M4  VOUT2 VOUT1 VDD   VDD  pmos4  W={WP}     L={LP}   ; gate at opposite output
M3  VOUT1 VOUT2 VDD   VDD  pmos4  W={WP}     L={LP}

* Optional load caps (can remove if not needed)
CL1 VOUT1 0 {CL}
CL2 VOUT2 0 {CL}

***** Simple MOS models (placeholders) *****
.model nmos4 NMOS (LEVEL=1 VTO=0.70 KP=120e-6 LAMBDA=0.04 GAMMA=0.5 PHI=0.6)
.model pmos4 PMOS (LEVEL=1 VTO=-0.70 KP=50e-6  LAMBDA=0.04 GAMMA=0.5 PHI=0.6)

***** Analyses *****
.op
*.ac dec 100 1 1e9                  ; for AC around the chosen operating point (optional)
*.tran 1u 200u                       ; for observing regeneration dynamics (optional)
.save v(vout1) v(vout2) v(net017) v(vb1) i(VDD)

.options post=2 nomod
.end
