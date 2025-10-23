* Diff pair + PMOS active loads (gate at VB1) + diode-connected PMOS at outputs
* Runnable deck for Ngspice

***** Parameters (X) *****
.param VDD=1.8
.param WN=10u  LN=0.5u               ; input pair NMOS size
.param WP=20u  LP=0.5u               ; PMOS load size
.param WNTAIL={2*WN} LNTAIL={LN}     ; tail NMOS size
.param VBIAS=1.0                     ; gate bias for tail NMOS and PMOS loads (VB1)
.param VCM=0.8  VID=10m              ; operating: input CM & differential amplitude
.param CL=10f                        ; small output load cap (optional)

***** Supplies *****
VDD  VDD  0  {VDD}
VVSS VSS  0  0

***** Inputs (DC differential around VCM) *****
VIN1 VIN1 0 {VCM + VID/2}
VIN2 VIN2 0 {VCM - VID/2}

***** Tail / Load bias *****
Vb   VB1  0 {VBIAS}

***** Devices *****
* NMOS differential pair (share tail node net015)
M2  VOUT2 VIN2 net015 VSS  nmos4  W={WN}     L={LN}
M0  VOUT1 VIN1 net015 VSS  nmos4  W={WN}     L={LN}

* NMOS tail current device (gate-biased by VB1)
M1  net015 VB1  VSS   VSS  nmos4  W={WNTAIL} L={LNTAIL}

* PMOS active loads (gate at VB1)
M6  VOUT2 VB1  VDD    VDD  pmos4  W={WP}     L={LP}
M5  VOUT1 VB1  VDD    VDD  pmos4  W={WP}     L={LP}

* Diode-connected PMOS at outputs (stiffen bias / raise Rout)
M4  VOUT2 VOUT2 VDD   VDD  pmos4  W={WP}     L={LP}
M3  VOUT1 VOUT1 VDD   VDD  pmos4  W={WP}     L={LP}

* Optional small load caps
CL1 VOUT1 0 {CL}
CL2 VOUT2 0 {CL}

***** Simple MOS models (placeholders) *****
.model nmos4 NMOS (LEVEL=1 VTO=0.70 KP=120e-6 LAMBDA=0.04 GAMMA=0.5 PHI=0.6)
.model pmos4 PMOS (LEVEL=1 VTO=-0.70 KP=50e-6  LAMBDA=0.04 GAMMA=0.5 PHI=0.6)

***** Analyses *****
.op
*.ac dec 100 1 1e9
*.tran 1u 200u
.save v(vout1) v(vout2) v(net015) v(vb1) i(VDD)

.options post=2 nomod
.end
