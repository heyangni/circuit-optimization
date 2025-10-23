* Diff pair + resistive loads to VDD + source-degeneration/feedback R2
* Runnable deck for Ngspice

***** Parameters (X) *****
.param VDD=1.8
.param VCM=0.8                 ; input common-mode
.param VID=10m                 ; differential amplitude (VIN1=+VID/2, VIN2=-VID/2)

.param RLOAD=20k               ; pull-up resistors to VDD (R0,R1)
.param RDEG=2k                 ; net07 <-> VOUT1 source-degeneration/feedback (R2)

.param WN=10u  LN=0.5u         ; NMOS input pair size (M0,M2)
.param WTAIL={2*WN} LTAIL={LN} ; NMOS tail (M1)
.param VBIAS=1.0               ; gate bias for tail NMOS (sets tail current)
.param CL=10f                  ; small output caps (optional)

***** Supplies *****
VDD  VDD  0  {VDD}
VVSS VSS  0  0

***** Inputs (DC differential around VCM) *****
VIN1 VIN1 0 {VCM + VID/2}
VIN2 VIN2 0 {VCM - VID/2}

***** Tail bias *****
Vb1  VB1  0 {VBIAS}

***** Devices *****
* Resistive loads pulling outputs up to VDD
R1  VOUT2 VDD {RLOAD}
R0  VOUT1 VDD {RLOAD}

* Source-degeneration / local feedback from net07 to left drain
R2  net07  VOUT1 {RDEG}

* NMOS differential pair (share tail node net07)
M2  VOUT2 VIN2 net07 VSS  nmos4  W={WN}     L={LN}
M0  VOUT1 VIN1 net07 VSS  nmos4  W={WN}     L={LN}

* NMOS tail current source (gate-biased by VB1)
M1  net07  VB1  VSS  VSS  nmos4  W={WTAIL}  L={LTAIL}

* Optional small load caps
CL1 VOUT1 0 {CL}
CL2 VOUT2 0 {CL}

***** Simple MOS models (placeholders) *****
.model nmos4 NMOS (LEVEL=1 VTO=0.70 KP=120e-6 LAMBDA=0.04 GAMMA=0.5 PHI=0.6)
*.model pmos4 PMOS (LEVEL=1 VTO=-0.70 KP=50e-6  LAMBDA=0.04 GAMMA=0.5 PHI=0.6)

***** Analyses *****
.op
*.ac dec 100 1 1e9             ; enable for small-signal analysis
*.tran 1u 200u                  ; enable for transient if you vary inputs/bias
.save v(vout1) v(vout2) v(net07) v(vb1) i(VDD)

.options post=2 nomod
.end
