{
  "schema_version": "cg.v1",
  "derived_from": "sg.v1",
  "design_id": "dp_resload_rdeg",
  "nodes": [
    {"id":"M2","ctype":"M","model":"nmos4","attrs":{"W":"{WN}","L":"{LN}"}},
    {"id":"M0","ctype":"M","model":"nmos4","attrs":{"W":"{WN}","L":"{LN}"}},
    {"id":"M1","ctype":"M","model":"nmos4","attrs":{"W":"{WTAIL}","L":"{LTAIL}"}},
    {"id":"R1","ctype":"R","attrs":{"value_expr":"{RLOAD}"}},
    {"id":"R0","ctype":"R","attrs":{"value_expr":"{RLOAD}"}},
    {"id":"R2","ctype":"R","attrs":{"value_expr":"{RDEG}"}}
  ],
  "edges": [
    {"u":"M0","v":"R0","via_nets":["VOUT1"],"role_pairs":[["M0.D","R0.p1","VOUT1"]],"class_set":["D-p1"],"weight":1},
    {"u":"M2","v":"R1","via_nets":["VOUT2"],"role_pairs":[["M2.D","R1.p1","VOUT2"]],"class_set":["D-p1"],"weight":1},

    {"u":"M0","v":"R2","via_nets":["VOUT1","net07"],"role_pairs":[["M0.D","R2.p2","VOUT1"],["M0.S","R2.p1","net07"]],"class_set":["D-p2","S-p1"],"weight":2},
    {"u":"R0","v":"R2","via_nets":["VOUT1"],"role_pairs":[["R0.p1","R2.p2","VOUT1"]],"class_set":["p1-p2"],"weight":1},

    {"u":"M2","v":"M0","via_nets":["net07"],"role_pairs":[["M2.S","M0.S","net07"]],"class_set":["S-S"],"weight":1},
    {"u":"M2","v":"M1","via_nets":["net07"],"role_pairs":[["M2.S","M1.D","net07"]],"class_set":["S-D"],"weight":1},
    {"u":"M0","v":"M1","via_nets":["net07"],"role_pairs":[["M0.S","M1.D","net07"]],"class_set":["S-D"],"weight":1},

    {"u":"M2","v":"R2","via_nets":["net07"],"role_pairs":[["M2.S","R2.p1","net07"]],"class_set":["S-p1"],"weight":1}
  ],
  "exclude_nets_rule": {
    "net_class_ignored": ["supply","bias","ref"],
    "ignore_testbench_components": true
  }
}